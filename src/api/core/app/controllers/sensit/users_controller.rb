require_dependency "sensit/api_controller"

module Sensit
  class UsersController < ApiController
    respond_to :json, :xml
    doorkeeper_for :show, :scopes => [:read_any_data, :manage_any_data, :read_any_percolations, :manage_any_percolations, :read_any_reports, :manage_any_reports, :read_any_subscriptions, :manage_any_subscriptions]
    
    # GET topics/1/feeds/1/data/:key
    def show
      @user = current_user
      respond_with @user
    end
  end
end
