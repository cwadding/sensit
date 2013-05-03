require_dependency "sensit/base_controller"

module Sensit
  class DevicesController < ApiController
    before_action :set_device, only: [:show, :edit, :update, :destroy]
    respond_to :json
    # GET /devices
    def index
      @devices = Device.all
      respond_with(@devices)
    end

    # GET /devices/1
    def show
      respond_with(@device)
    end

    # POST /devices
    def create
      @device = Device.new(device_params)

      if @device.save
        
      else
        
      end
      respond_with(@device,:status => 200, :template => "sensit/devices/show")
    end

    # PATCH/PUT /devices/1
    def update
      if @device.update(device_params)
        
      else
        
      end
      respond_with(@device,:status => 200, :template => "sensit/devices/show")
    end

    # DELETE /devices/1
    def destroy
      @device.destroy
      respond_with(@sensor, :status => 204)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_device
        @device = Device.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def device_params
        params.require(:device).permit(:title, :url, :status, :description, :icon, :user_id, :location_id)
      end
  end
end
