require_dependency "sensit/api_controller"

module Sensit
  class FeedsController < ApiController
    before_action :set_feed, only: [:show, :update, :destroy]
    respond_to :json

    # GET /topics/1/feeds/1
    def show
      respond_with(@feed)
    end

    # POST /topic/1/feeds
    def create
      if params.has_key?(:feeds)
        topic = Topic.find(params[:topic_id])
        importer = Topic::Feed::Importer.new({index: elastic_index_name, type: elastic_type_name, :topic_id => topic.id, :feeds => feeds_params})
        @feeds = importer.feeds
        if importer.save
          respond_with(@feeds,:status => :created, :template => "sensit/feeds/index")
        else
          render(:json => "{\"errors\":#{importer.errors.to_json}}", :status => :unprocessable_entity)
        end
      else
        topic = Topic.find(params[:topic_id])
        @feed = Topic::Feed.new(feed_params.merge!({index: elastic_index_name, type: elastic_type_name, :topic_id => topic.id})) 
        if @feed.save
          respond_with(@feed,:status => :created, :template => "sensit/feeds/show")
        else
          render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /topics/1/feeds/1
    def update
      if @feed.update_attributes(feed_update_params)
        respond_with(@feed,:status => :ok, :template => "sensit/feeds/show")
      else
        render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /topics/1/feeds/1
    def destroy
      Topic::Feed.destroy({index: elastic_index_name, type: elastic_type_name, id:  params[:id].to_s})
      head :status => :no_content
    end

    private

      def elastic_index_name
        Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : params[:topic_id].to_s
      end
      def elastic_type_name
        Rails.env.test? ? ELASTIC_SEARCH_INDEX_TYPE : params[:topic_id].to_s
      end      
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Topic::Feed.find({index: elastic_index_name, type: elastic_type_name, id:  params[:id].to_s})
      end

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
