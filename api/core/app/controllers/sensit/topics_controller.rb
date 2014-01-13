require_dependency "sensit/api_controller"

module Sensit
  class TopicsController < ApiController
    before_action :set_topic, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET 1/topics
    def index
      # scope all to the api key that is being used
      @topics = current_user.topics.page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@topics)
    end

    # GET 1/topics/1
    def show
        respond_with(@topic)
    end

    # POST 1/topics
    def create
      @topic = current_user.topics.build(topic_params)
      if @topic.save
        respond_with(@topic,:status => :created, :template => "sensit/topics/show")
      else
        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT 1/topics/1
    def update
      if @topic.update(topic_params)
        respond_with(@topic,:status => 200, :template => "sensit/topics/show")
      else
        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE 1/topics/1
    def destroy
      @topic.destroy
      head :status => :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_topic
        @topic = current_user.topics.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def topic_params
        @topic_params ||= params.require(:topic).permit(:name, :description, :fields => [:name, :key])
      end
  end
end
