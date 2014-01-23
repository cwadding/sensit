require_dependency "sensit/api_controller"

module Sensit
  class UsersController < ApiController
    respond_to :json
    doorkeeper_for :show
    
    # GET topics/1/feeds/1/data/:key
    def show
      @user = current_user
      respond_with @user
    end
  end
end
