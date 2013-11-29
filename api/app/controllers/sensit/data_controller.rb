require_dependency "sensit/api_controller"

module Sensit
  class DataController < ApiController
    before_action :set_feed, only: [:show, :update, :destroy]
    respond_to :json
    # GET /topics/1/feeds/1/data
    def index
      # @values = Topic::Feed::DataRow.where(feed_id: params[:feed_id])
    end

    # GET topics/1/feeds/1/data/1
    def show
    end

    # POST topics/1/feeds/1/data
    def create
      feed = Topic::Feed.find(params[:feed_id])
      # @values = Topic::Feed::DataRow.new(data_params)
      # @data.feed = feed
      # if @data.save
      # else
      # end
      respond_with(@feed,:status => 200, :template => "sensit/data/show")
    end

    # PATCH/PUT topics/1/feeds/1/data/1
    def update
      # if @data.update(data_params)
      # else
      # end
      # respond_with(@data,:status => 200, :template => "sensit/data/show")
    end

    # DELETE topics/1/feeds/1/data/1
    def destroy
      @data.destroy
      respond_with(@data, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Topic::Feed.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def data_params
        params.require(:data).permit(:key, :value)
      end
  end
end
