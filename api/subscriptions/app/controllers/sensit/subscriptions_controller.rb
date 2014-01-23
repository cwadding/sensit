require_dependency "sensit/api_controller"

module Sensit
  class SubscriptionsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_subscriptions, :read_application_subscriptions]
    doorkeeper_for :create, :update, :scopes => [:write_any_subscriptions, :write_application_subscriptions]
    doorkeeper_for :destroy,  :scopes => [:delete_any_subscriptions, :delete_application_subscriptions]
    respond_to :json

    # GET /subscriptions
    def index
      topic = scoped_owner(:read_any_subscriptions).topics.find(params[:topic_id])
      @subscriptions = topic.subscriptions
    end

    # GET /subscriptions/1
    def show
      @subscription = scoped_owner(:read_any_subscriptions).topics.find(params[:topic_id]).subscriptions.find(params[:id])
      respond_with(@subscription)
    end

    # POST /subscriptions
    def create
      @subscription = scoped_owner(:write_any_subscriptions).topics.find(params[:topic_id]).subscriptions.find(params[:id])
      topic = current_user.topics.find(params[:topic_id])
      @subscription = topic.subscriptions.build(subscription_params)
      if @subscription.save
        SubscriptionsWorker.perform_async(@subscription.id)
        respond_with(@subscription,:status => :created, :template => "sensit/subscriptions/show")
      else
        render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /subscriptions/1
    def update
      @subscription = scoped_owner(:write_any_subscriptions).topics.find(params[:topic_id]).subscriptions.find(params[:id])
      if @subscription.update(subscription_params)
        # SubscriptionsWorker.perform_async(@subscription.id)
        respond_with(@subscription,:status => :ok, :template => "sensit/subscriptions/show")
      else
        render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /subscriptions/1
    def destroy
      @subscription = scoped_owner(:delete_any_subscriptions).topics.find(params[:topic_id]).subscriptions.find(params[:id])
      # SubscriptionsWorker kill a job
      @subscription.destroy
      head :status => :no_content
    end

    private

      # Only allow a trusted parameter "white list" through.
      def subscription_params
        params.require(:subscription).permit(:name, :host, :auth_token, :protocol)
      end
  end
end
