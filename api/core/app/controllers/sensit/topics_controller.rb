require_dependency "sensit/api_controller"

module Sensit
  class TopicsController < ApiController
    include ::DoorkeeperDataAuthorization
    respond_to :json
    # GET 1/topics
    def index
      @topics = scoped_owner(:read_any_data).topics.page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@topics)
    end

    # GET 1/topics/1
    def show
      @topic = scoped_owner(:read_any_data).topics.find(params[:id])
      respond_with(@topic)
    end

    # POST 1/topics
    def create
      @topic = current_user.topics.build(topic_params.merge!(application_id: doorkeeper_token.application_id))
      if @topic.save
        respond_with(@topic,:status => :created, :template => "sensit/topics/show")
      else
        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT 1/topics/1
    def update
      @topic = scoped_owner(:write_any_data).topics.find(params[:id])
      if @topic.update(topic_params)
        respond_with(@topic,:status => 200, :template => "sensit/topics/show")
      else
        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE 1/topics/1
    def destroy
      @topic = scoped_owner(:delete_any_data).topics.find(params[:id])
      @topic.destroy
      head :status => :no_content
    end

    private

      # Only allow a trusted parameter "white list" through.
      def topic_params
        @topic_params ||= params.require(:topic).permit(:name, :description)
      end
  end
end
