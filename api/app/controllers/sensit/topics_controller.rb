require_dependency "sensit/base_controller"

module Sensit
  class TopicsController < ApiController
    before_action :set_topic, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics
    def index
      @topics = Node::Topic.all
      respond_with(@topics)
    end

    # GET /nodes/1/topics/1
    def show
        respond_with(@topic)
    end

    # POST /nodes/1/topics
    def create
      node = Node.find(params[:node_id])
      @topic = Node::Topic.new(topic_params)
      @topic.node = node
      if @topic.save
        
      else

      end
      respond_with(@topic,:status => 200, :template => "sensit/topics/show")
    end

    # PATCH/PUT /nodes/1/topics/1
    def update
      if @topic.update(topic_params)

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
      def set_topic
        @topic = Node::Topic.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def topic_params
        params.require(:topic).permit(:name, :node_id)
      end
  end
end
