require_dependency "sensit/base_controller"

module Sensit
  class FeedsController < ApiController
    before_action :set_feed, only: [:show, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics/1/feeds
    def index
      @feeds = []
      if params.has_key?(:body)
        @feeds = Node::Topic::Feed.search({index: params[:node_id].to_s, type: params[:topic_id].to_s, body: params[:body]})
      else
        @feeds = Node::Topic::Feed.search({index: params[:node_id].to_s, type: params[:topic_id].to_s})
      end
      
      respond_with(@feeds)
    end

    # GET /nodes/1/topics/1/feeds/1
    def show
      respond_with(@feed)
    end

    # POST /nodes/1/topic/1/feeds
    def create
      @feed = Node::Topic::Feed.new(feed_params.merge!({index: params[:node_id].to_s, type: params[:topic_id].to_s, :topic_id => params[:topic_id]})) 
      if @feed.save
        respond_with(@feed,:status => 200, :template => "sensit/feeds/show")
      else
        render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
      end
      
    end

    # PATCH/PUT /nodes/1/topics/1/feeds/1
    def update
      if @feed.update_attributes(feed_update_params)
        respond_with(@feed,:status => 200, :template => "sensit/feeds/show")
      else
        render(:json => "{\"errors\":#{@feed.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /nodes/1/topics/1/feeds/1
    def destroy
      Node::Topic::Feed.destroy({index: params[:node_id].to_s, type: params[:topic_id].to_s, id:  params[:id].to_s})
      head :status => 204
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Node::Topic::Feed.find({index: params[:node_id].to_s, type: params[:topic_id].to_s, id:  params[:id].to_s})
      end

      # Only allow a trusted parameter "white list" through.
      def feed_update_params
        params.require(:feed).require(:values).permit!
      end

      def feed_params
        fields = Node::Topic::Field.where(:topic_id => params[:topic_id]).map(&:key)
        params.require(:feed).permit(:at, :values => fields)
      end
  end
end
