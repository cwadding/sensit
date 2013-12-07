require_dependency "sensit/api_controller"

module Sensit
  class TopicsController < ApiController
    before_action :set_topic, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET 1/topics
    def index
      # scope all to the api key that is being used
      @topics = Topic.all
      respond_with(@topics)
    end

    # GET 1/topics/1
    def show
        @body = params.delete(:body)
        respond_with({topic: @topic, query: @body})
    end

    # POST 1/topics
    def create
      @topic = Topic.new(topic_params)
      if @topic.save
        # create the elasticsearch index
        client = ::Elasticsearch::Client.new
        client.indices.create({:index => @topic.id, :type => @topic.id}) unless (client.indices.exists index: @topic.id)
        respond_with(@topic,:status => 200, :template => "sensit/topics/show")
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
      head :status => 204
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_topic
        @topic = Topic.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def topic_params
        params.require(:topic).permit(:name, :description)
      end
  end
end
