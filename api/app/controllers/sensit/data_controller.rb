require_dependency "sensit/base_controller"

module Sensit
  class DataController < ApiController
    before_action :set_feed, only: [:show, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics/1/feeds/1/data
    def index
      # @values = Node::Topic::Feed::DataRow.where(feed_id: params[:feed_id])
    end

    # GET /nodes/topics/feeds/data/1
    def show
    end

    # POST /nodes/topics/feeds/data
    def create
      feed = Node::Topic::Feed.find(params[:feed_id])
      # @values = Node::Topic::Feed::DataRow.new(data_params)
      # @data.feed = feed
      # if @data.save
      # else
      # end
      respond_with(@feed,:status => 200, :template => "sensit/data/show")
    end

    # PATCH/PUT /nodes/topics/feeds/data/1
    def update
      # if @data.update(data_params)
      # else
      # end
      # respond_with(@data,:status => 200, :template => "sensit/data/show")
    end

    # DELETE /nodes/topics/feeds/data/1
    def destroy
      @data.destroy
      respond_with(@data, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Node::Topic::Feed.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def data_params
        params.require(:data).permit(:key, :value)
      end
  end
end
