require_dependency "sensit/api_controller"

module Sensit
  class SubscriptionsController < ApiController
    before_action :set_subscription, only: [:show, :update, :destroy]
    respond_to :json

    # GET /subscriptions
    def index
      topic = Topic.find(params[:topic_id])
      @subscriptions = topic.subscriptions
    end

    # GET /subscriptions/1
    def show
      respond_with(@subscription)
    end

    # POST /subscriptions
    def create
      topic = Topic.find(params[:topic_id])
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
      if @subscription.update(subscription_params)
        # SubscriptionsWorker.perform_async(@subscription.id)
        respond_with(@subscription,:status => :ok, :template => "sensit/subscriptions/show")
      else
        render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /subscriptions/1
    def destroy
      # SubscriptionsWorker kill a job
      @subscription.destroy
      head :status => :no_content
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_subscription
        @subscription = Sensit::Topic::Subscription.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def subscription_params
        params.require(:subscription).permit(:name, :host, :auth_token, :protocol)
      end
  end
end
