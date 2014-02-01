require_dependency "sensit/api_controller"

module Sensit
  class FeedsController < ApiController
    include ::DoorkeeperDataAuthorization
    respond_to :json, :xml

    # GET /topics/1/feeds/1
    def show
      # need to add application_id to feed
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        @feed = Topic::Feed.find({index: elastic_index_name, type: elastic_type_name, id: params[:id].to_s})
        respond_with(@feed)
      end
    end

    # POST /topic/1/feeds
    def create
      if params.has_key?(:feeds)
        importer = Topic::Feed::Importer.new({index: elastic_index_name, type: elastic_type_name, :feeds => feeds_params})
        if importer.save
          @feeds = importer.feeds
          respond_with(@feeds,:status => :created, :template => "sensit/feeds/index")
        else
          render(:json => "{\"errors\":#{importer.errors.to_json}}", :status => :unprocessable_entity)
        end
      else
        if attempting_to_access_topic_from_another_application_without_privilage("write_any_data")
          head :unauthorized
        else
          @feed = Topic::Feed.new(feed_params.merge!({index: elastic_index_name, type: elastic_type_name})) 
          if @feed.save
            respond_with(@feed,:status => :created, :template => "sensit/feeds/show")
          else
            render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
          end
        end
      end
    end

    # PATCH/PUT /topics/1/feeds/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("write_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else        
        @feed = Topic::Feed.find({index: elastic_index_name, type: elastic_type_name, id: params[:id].to_s})
        if @feed.update_attributes(feed_update_params)
          respond_with(@feed,:status => :ok, :template => "sensit/feeds/show")
        else
          render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /topics/1/feeds/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("delete_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        Topic::Feed.destroy({index: elastic_index_name, type: elastic_type_name, id:  params[:id].to_s})
        head :status => :no_content
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      # Only allow a trusted parameter "white list" through.
      def feed_update_params
        params.require(:feed).require(:values).permit!
      end

      def feed_params
        all_keys = params.require(:feed)[:values].keys
        params.require(:feed).permit(:at, :tz, :values => all_keys)
      end

      def feeds_params
        if params[:feeds] && params[:feeds].is_a?(Hash)
          all_keys = params.require(:feeds)[0][:values].keys
          params.require(:feeds).map do |p|
            ActionController::Parameters.new(p.to_hash).permit(:at, :tz, :values => all_keys)
          end
        else
          params.require(:feeds)
        end
      end
  end
end