require_dependency "sensit/api_controller"

module Sensit
  class TopicsController < ApiController
    include ::DoorkeeperDataAuthorization
    respond_to :json, :xml
    # GET 1/topics
    def index
      @topics = scoped_owner("read_any_data").topics.page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@topics)
    end

    # GET 1/topics/1
    def show
      @topic = scoped_owner("read_any_data").topics.find(params[:id])
      respond_with(@topic)
    end

    # POST 1/topics
    def create
      if (attempting_to_write_to_another_application_without_privilage)
        head :unauthorized
      else
        @topic = current_user.topics.build(topic_params)
        if @topic.save
          respond_with(@topic,:status => :created, :template => "sensit/topics/show")
        else
          render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT 1/topics/1
    def update
      if (attempting_to_write_to_another_application_without_privilage)
        head :unauthorized
      else
        @topic = scoped_owner("write_any_data").topics.find(params[:id])
        if @topic.update(topic_params)
          respond_with(@topic, :status => 200, :template => "sensit/topics/show")
        else
          render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE 1/topics/1
    def destroy
      @topic = scoped_owner("delete_any_data").topics.find(params[:id])
      @topic.destroy
      head :status => :no_content
    end

    private
      def attempting_to_write_to_another_application_without_privilage
        !has_scope?("write_any_data") && application_id_from_params.has_key?(:application_id) && application_id_from_params[:application_id].to_s != doorkeeper_token.application_id.to_s
      end

      def application_id_from_params
        @application_id_from_params ||= params.require(:topic).permit(:application_id)
      end
      # Only allow a trusted parameter "white list" through.
      def topic_params
        @topic_params ||= strong_topic_params
      end

      def strong_topic_params
        permitted_attributes = [:name, :description, :ttl]
        permitted_attributes << :application_id if has_scope?("write_any_data")
        topic_params = params.require(:topic).permit(permitted_attributes)
        topic_params.merge!(application_id: doorkeeper_token.application_id) unless topic_params.has_key?(:application_id)
        topic_params
      end
  end
end