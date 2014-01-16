require_dependency "sensit/api_controller"

module Sensit
  class FieldsController < ApiController
    before_action :set_field, only: [:show, :update, :destroy]
    respond_to :json
    # GET /topics/1/fields
    def index
      @fields = Topic::Field.joins(:topic, :topic => :user).where(:sensit_topics => {:slug => params[:topic_id]}, :sensit_users => {:id => session[:user_id]}).page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@fields)
    end

    # GET /topics/1/fields/1
    def show
      respond_with(@field)
    end

    # POST /topics/1/fields
    def create
      topic = current_user.topics.find(params[:topic_id])
      @field = topic.fields.build(field_params)
      if @field.save
        respond_with(@field,:status => :created, :template => "sensit/fields/show")
      else
        render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /topics/1/fields/1
    def update
      if @field.update(field_params)
        respond_with(@field,:status => :ok, :template => "sensit/fields/show")
      else
        render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE topics/1/fields/1
    def destroy
      @field.destroy
      head :status => :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field
        topic = current_user.topics.find(params[:topic_id])
        raise ActiveRecord::RecordNotFound if topic.blank?
        @field = topic.fields.find(params[:id])
        raise ActiveRecord::RecordNotFound if @field.blank?
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.require(:field).permit(:name, :key)
      end
  end
end
