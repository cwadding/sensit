require_dependency "sensit/base_controller"

module Sensit
  class Device::Sensor::DataPointsController < ApiController
    before_action :set_data_point, only: [:show, :update, :destroy]
    respond_to :json
    # GET /devices/1/sensors/1/data_points
    def index
      @data_points = Device::Sensor::DataPoint.all
      respond_with(@data_points)
    end

    # GET /devices/1/sensors/1/data_points/1
    def show
      respond_with(@data_point)
    end

    # POST /devices/1/sensor/1/data_points
    def create
      @data_point = Device::Sensor::DataPoint.new(data_point_params)

      if @data_point.save

      else

      end
      respond_with(@data_point,:status => 200, :template => "sensit/device/sensor/data_points/show")
    end

    # PATCH/PUT /devices/1/sensors/1/data_points/1
    def update
      if @data_point.update(data_point_params)
        
      else
        
      end
      respond_with(@data_point,:status => 200, :template => "sensit/device/sensor/data_points/show")
    end

    # DELETE /devices/1/sensors/1/data_points/1
    def destroy
      @data_point.destroy
      respond_with(@data_point, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_data_point
        @data_point = Device::Sensor::DataPoint.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def data_point_params
        params.require(:data_point).permit(:sensor_id, :at, :value)
      end
  end
end
