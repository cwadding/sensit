require_dependency "sensit/api_controller"

module Sensit
  class FieldsController < ApiController
    include ::DoorkeeperDataAuthorization    
    respond_to :json, :xml
    # GET /topics/1/fields
    def index
      if has_scope?("read_any_data")
        @fields = Topic::Field.joins(:topic, :topic => :user).where(:sensit_topics => {:slug => params[:topic_id]}, :sensit_users => {:id => doorkeeper_token.resource_owner_id}).page(params[:page] || 1).per(params[:per] || 10)
      else
        @fields = Topic::Field.joins(:topic).where(:sensit_topics => {:slug => params[:topic_id], application_id: doorkeeper_token.application_id}).page(params[:page] || 1).per(params[:per] || 10)
      end
      respond_with(@fields)
    end

    # GET /topics/1/fields/1
    def show
      @field = set_field_in_scope("read_any_data")
      respond_with(@field)
    end

    # POST /topics/1/fields
    def create
      if (attempting_to_access_topic_from_another_application_without_privilage("manage_any_data"))
        head :unauthorized
      else
        topic = scoped_owner("manage_any_data").topics.find(params[:topic_id])
        @field = topic.fields.build(field_params)
        if @field.save
          respond_with(@field,:status => :created, :template => "sensit/fields/show")
        else
          render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /topics/1/fields/1
    def update
      if (attempting_to_access_topic_from_another_application_without_privilage("manage_any_data"))
        raise ActiveRecord::RecordNotFound
      else
        @field = set_field_in_scope("manage_any_data")
        if @field.update(field_params)
          respond_with(@field,:status => :ok, :template => "sensit/fields/show")
        else
          render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE topics/1/fields/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_data")
        raise ActiveRecord::RecordNotFound
      else
        @field = set_field_in_scope("manage_any_data")
        @field.destroy
        head :status => :no_content
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field_in_scope(scope)
        topic = scoped_owner(scope).topics.find(params[:topic_id])
        raise ActiveRecord::RecordNotFound if topic.blank?
        field = topic.fields.find(params[:id])
        raise ActiveRecord::RecordNotFound if field.blank?
        field
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.require(:field).permit(:name, :key)
      end
  end
end
