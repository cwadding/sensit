require_dependency "sensit/api_controller"

module Sensit
  class FieldsController < ApiController
    before_action :set_field, only: [:show, :update, :destroy]
    respond_to :json
    # GET /topics/1/fields
    def index
      topic = Topic.find(params[:topic_id])
      @fields = topic.fields
      respond_with(@fields)
    end

    # GET /topics/1/fields/1
    def show
      respond_with(@field)
    end

    # POST /topics/1/fields
    def create
      topic = Topic.find(params[:topic_id])
      @field = topic.fields.build(field_params)
      if @field.save
        respond_with(@field,:status => 200, :template => "sensit/fields/show")
      else
        render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /topics/1/fields/1
    def update
      if @field.update(field_params)
        respond_with(@field,:status => 200, :template => "sensit/fields/show")
      else
        render(:json => "{\"errors\":#{@field.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE topics/1/fields/1
    def destroy
      @field.destroy
      head :status => 204
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field
        @field = Topic::Field.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.require(:field).permit(:name, :key)
      end
  end
end
