require_dependency "sensit/base_controller"

module Sensit
  class FieldsController < ApiController
    before_action :set_field, only: [:show, :update, :destroy]
    respond_to :json
    # GET /nodes/1/topics/1/fields
    def index
      @fields = Node::Topic::Field.where(topic_id: params[:topic_id])
      respond_with(@fields)
    end

    # GET /nodes/1/topics/1/fields/1
    def show
      respond_with(@field)
    end

    # POST /nodes/1/topics/1/fields
    def create
      topic = Node::Topic.find(params[:topic_id])
      @field = Node::Topic::Field.new(field_params)
      @field.topic = topic
      if @field.save

      else

      end
      respond_with(@field,:status => 200, :template => "sensit/fields/show")
    end

    # PATCH/PUT /nodes/1/topics/1/fields/1
    def update
      if @field.update(field_params)

      else

      end
      respond_with(@field,:status => 200, :template => "sensit/fields/show")
    end

    # DELETE /nodes/topics/fields/1
    def destroy
      @field.destroy
      respond_with(@field, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_field
        @field = Node::Topic::Field.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def field_params
        params.require(:field).permit(:name, :key)
      end
  end
end
