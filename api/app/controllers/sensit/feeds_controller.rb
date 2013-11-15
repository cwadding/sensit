require_dependency "sensit/base_controller"

module Sensit
  class FeedsController < ApiController
    before_action :set_feed, only: [:show, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics/1/feeds
    def index
      @feeds = Node::Topic::Feed.where(topic_id: params[:topic_id])
      respond_with(@feeds)
    end

    # GET /nodes/1/topics/1/feeds/1
    def show
      respond_with(@feed)
    end

    # POST /nodes/1/topic/1/feeds
    def create
      topic = Node::Topic.find(params[:topic_id])
      @feed = Node::Topic::Feed.new(feed_params)
      @feed.topic = topic
      
      if @feed.save

      else

      end
      respond_with(@feed,:status => 200, :template => "sensit/feeds/show")
    end

    # PATCH/PUT /nodes/1/topics/1/feeds/1
    def update
      if @feed.update(feed_params)
        
      else
        
      end
      respond_with(@feed,:status => 200, :template => "sensit/feeds/show")
    end

    # DELETE /nodes/1/topics/1/feeds/1
    def destroy
      @feed.destroy
      respond_with(@feed, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Node::Topic::Feed.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def feed_params
        params.require(:feed).permit(:at, :data => [])
      end
  end
end
