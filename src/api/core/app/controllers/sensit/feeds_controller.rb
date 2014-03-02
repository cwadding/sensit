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
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_data")
        head :unauthorized
      else
        topic = scoped_owner("manage_any_data").topics.find(params[:topic_id])
        if params.has_key?(:feeds)
          # have an async option to avoid timeouts and just return immediately with the confirmation that it was received
          importer = Topic::Feed::Importer.new({index: elastic_index_name, type: elastic_type_name, :fields => topic.fields, :feeds => feeds_params(topic.fields)})
          # debugger
          if importer.save
            @fields = topic.fields
            @feeds = importer.feeds
            respond_with(@feeds,:status => :created, :template => "sensit/feeds/index")
          else
            render(:json => "{\"errors\":#{importer.errors.to_json}}", :status => :unprocessable_entity)
          end
        else
            @feed = Topic::Feed.new(feed_params(topic.fields).merge!({index: elastic_index_name, type: elastic_type_name})) 
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
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        @feed = Topic::Feed.find({index: elastic_index_name, type: elastic_type_name, id: params[:id].to_s})        
        if @feed.update_attributes(feed_update_params(@feed.fields))
          respond_with(@feed,:status => :ok, :template => "sensit/feeds/show")
        else
          render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /topics/1/feeds/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_data")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        Topic::Feed.destroy({index: elastic_index_name, type: elastic_type_name, id:  params[:id].to_s})
        head :status => :no_content
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      # Only allow a trusted parameter "white list" through.
      def feed_update_params(fields)
        values = fields.map(&:key)
        params.require(:feed).require(:data).permit(values)
      end

      def feed_params(fields)
        if fields.empty?
          feed_hash = params.require(:feed).permit(:at, :tz).tap do |whitelisted|
            whitelisted[:data] =  params[:feed][:data]
          end
        else
          feed_hash = params.require(:feed).permit(:at, :tz, :data => fields.map(&:key))
        end
        feed_hash.merge!(fields: fields)
      end

      def feeds_params(fields)
        values = fields.map(&:key)
        if params[:feeds] && params[:feeds].is_a?(Hash)
          params.require(:feeds).map do |p|
            ActionController::Parameters.new(p.to_hash).permit(:at, :tz, :data => values)
          end
        else
          params.require(:feeds)
        end
      end

  end
end
