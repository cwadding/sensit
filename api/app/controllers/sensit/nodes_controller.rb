require_dependency "sensit/base_controller"

module Sensit
  class NodesController < ApiController
    before_action :set_node, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET /nodes
    def index
      @nodes = Node.all
      respond_with(@nodes)
    end

    # GET /nodes/1
    def show
      respond_with(@node)
    end

    # POST /nodes
    def create
      @node = Node.new(node_params)

      if @node.save
        
      else
        
      end
      respond_with(@node,:status => 200, :template => "sensit/nodes/show")
    end

    # PATCH/PUT /nodes/1
    def update
      if @node.update(node_params)
        
      else
        
      end
      respond_with(@node,:status => 200, :template => "sensit/nodes/show")
    end

    # DELETE /nodes/1
    def destroy
      @node.destroy
      respond_with(@topic, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_node
        @node = Node.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def node_params
        params.require(:node).permit(:name, :description)
      end
  end
end
