require_dependency "sensit/base_controller"

module Sensit
  class TopicsController < ApiController
    before_action :set_node_topic, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics
    def index
      @topics = Node::Topic.all
      respond_with(@topics)
    end

    # GET /nodes/1/topics/1
    def show
      respond_with(@topics)
    end

    # POST /nodes/1/topics
    def create
      @topic = Node::Topic.new(node_topic_params)
      if @topic.save
        
      else

      end
      respond_with(@topic,:status => 200, :template => "sensit/topics/show")
    end

    # PATCH/PUT /nodes/1/topics/1
    def update
      if @topic.update(node_topic_params)

      else
        
      end
      respond_with(@topic,:status => 200, :template => "sensit/topics/show")
    end

    # DELETE /nodes/1/topics/1
    def destroy
      @topic.destroy
      respond_with(@topic, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_node_topic
        @topic = Node::Topic.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def node_topic_params
        params.require(:node_topic).permit(:name, :node_id)
      end
  end
end
