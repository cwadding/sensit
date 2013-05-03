require_dependency "sensit/base_controller"

module Sensit
  class Device::SensorsController < ApiController
    before_action :set_device_sensor, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET /devices/1/sensors
    def index
      @sensors = Device::Sensor.all
      respond_with(@sensors)
    end

    # GET /devices/1/sensors/1
    def show
      respond_with(@sensors)
    end

    # POST /devices/1/sensors
    def create
      @sensor = Device::Sensor.new(device_sensor_params)
      if @sensor.save
        
      else

      end
      respond_with(@sensor,:status => 200, :template => "sensit/device/sensors/show")
    end

    # PATCH/PUT /devices/1/sensors/1
    def update
      if @sensor.update(device_sensor_params)

      else
        
      end
      respond_with(@sensor,:status => 200, :template => "sensit/device/sensors/show")
    end

    # DELETE /devices/1/sensors/1
    def destroy
      @sensor.destroy
      respond_with(@sensor, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_device_sensor
        @sensor = Device::Sensor.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def device_sensor_params
        params.require(:device_sensor).permit(:unit_id, :min_value, :max_value, :start_value, :device_id)
      end
  end
end
