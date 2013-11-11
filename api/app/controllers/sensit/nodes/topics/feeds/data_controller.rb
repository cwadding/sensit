require_dependency "sensit/base_controller"

module Sensit
  class Nodes::Topics::Feeds::DataController < ApiController
    before_action :set_data, only: [:show, :update, :destroy]
    respond_to :json
    # GET /nodes/topics/feeds/data
    def index
      @data = Node::Topic::Feed::DataRow.all
    end

    # GET /nodes/topics/feeds/data/1
    def show
    end

    # POST /nodes/topics/feeds/data
    def create
      @data = Node::Topic::Feed::DataRow.new(data_params)

      if @data.save
      else
      end
      respond_with(@feed,:status => 200, :template => "sensit/nodes/topics/feeds/data/show")
    end

    # PATCH/PUT /nodes/topics/feeds/data/1
    def update
      if @data.update(data_params)
      else
      end
      respond_with(@data,:status => 200, :template => "sensit/nodes/topics/feeds/data/show")
    end

    # DELETE /nodes/topics/feeds/data/1
    def destroy
      @data.destroy
      respond_with(@data, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_data
        @data = Node::Topic::Feed::DataRow.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def data_params
        params.require(:data).permit(:key, :value)
      end
  end
end
