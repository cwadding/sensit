require_dependency "sensit/api_controller"

module Sensit
  class SubscriptionsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_subscriptions, :read_application_subscriptions]
    doorkeeper_for :create, :update, :destroy, :scopes => [:manage_any_subscriptions, :manage_application_subscriptions]
    
    respond_to :json, :xml

    # GET /subscriptions
    def index
      @subscriptions = scoped_owner("read_any_subscriptions").subscriptions.page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@subscriptions)
    end

    # GET /subscriptions/1
    def show
      @subscription = scoped_owner("read_any_subscriptions").subscriptions.find(params[:id])
      respond_with(@subscription)
    end

    # POST /subscriptions
    def create
      if attempting_to_write_to_another_application_without_privilage(:subscription)
        head :unauthorized
      else
        @subscription = current_user.subscriptions.build(subscription_params)
        if @subscription.save
          respond_with(@subscription,:status => :created, :template => "sensit/subscriptions/show")
        else
          render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /subscriptions/1
    def update
      @subscription = scoped_owner("manage_any_subscriptions").subscriptions.find(params[:id])
      if @subscription.update(subscription_params)
        # SubscriptionsWorker.perform_async(@subscription.id)
        respond_with(@subscription,:status => :ok, :template => "sensit/subscriptions/show")
      else
        render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /subscriptions/1
    def destroy     
      @subscription = scoped_owner("manage_any_subscriptions").subscriptions.find(params[:id])
      # SubscriptionsWorker kill a job
      @subscription.destroy
      head :status => :no_content
    end

    private

      # Only allow a trusted parameter "white list" through.
      def subscription_params
        permitted_attributes = [:name]
        if params[:subscription] && params[:subscription].has_key?(:uri)
          permitted_attributes << :uri if has_scope?("manage_any_subscriptions")
        else
          permitted_attributes.concat([:host, :protocol, :username, :password, :port])
        end
        permitted_attributes << :application_id if has_scope?("manage_any_subscriptions")
        temp_params = params.require(:subscription).permit(permitted_attributes)
        temp_params.merge!(application_id: doorkeeper_token.application_id) unless temp_params.has_key?(:application_id)
        temp_params
      end
  end
end
