require_dependency "sensit/api_controller"

module Sensit
  class SubscriptionsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_subscriptions, :read_application_subscriptions]
    doorkeeper_for :create, :update, :scopes => [:write_any_subscriptions, :write_application_subscriptions]
    doorkeeper_for :destroy,  :scopes => [:delete_any_subscriptions, :delete_application_subscriptions]
    respond_to :json, :xml

    # GET /subscriptions
    def index
      joins = {:user_id => doorkeeper_token.resource_owner_id, :slug => params[:topic_id]}
      joins.merge!(:application_id => doorkeeper_token.application_id) unless has_scope?("read_any_subscriptions")
      @subscriptions = Topic::Subscription.joins(:topic).where(:sensit_topics => joins).page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@subscriptions)
    end

    # GET /subscriptions/1
    def show
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_subscriptions")
        raise ::ActiveRecord::RecordNotFound
      else
        @subscription = scoped_owner("read_any_subscriptions").topics.find(params[:topic_id]).subscriptions.find(params[:id])
        respond_with(@subscription)
      end
    end

    # POST /subscriptions
    def create
      if attempting_to_access_topic_from_another_application_without_privilage("write_any_subscriptions")
        head :unauthorized
      else
        topic = scoped_owner("write_any_subscriptions").topics.find(params[:topic_id])
        @subscription = topic.subscriptions.build(subscription_params)
        if @subscription.save
          SubscriptionsWorker.perform_async({action: :create, subscription_id: @subscription.to_param})
          respond_with(@subscription,:status => :created, :template => "sensit/subscriptions/show")
        else
          render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /subscriptions/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("write_any_subscriptions")
        raise ::ActiveRecord::RecordNotFound
      else
        @subscription = scoped_owner("write_any_subscriptions").topics.find(params[:topic_id]).subscriptions.find(params[:id])
        if @subscription.update(subscription_params)
          # SubscriptionsWorker.perform_async(@subscription.id)
          respond_with(@subscription,:status => :ok, :template => "sensit/subscriptions/show")
        else
          render(:json => "{\"errors\":#{@subscription.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /subscriptions/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("delete_any_subscriptions")
        raise ::ActiveRecord::RecordNotFound
      else      
        @subscription = scoped_owner("delete_any_subscriptions").topics.find(params[:topic_id]).subscriptions.find(params[:id])
        # SubscriptionsWorker kill a job
        @subscription.destroy
        head :status => :no_content
      end
    end

    private

      # Only allow a trusted parameter "white list" through.
      def subscription_params
        params.require(:subscription).permit(:name, :host, :auth_token, :protocol)
      end
  end
end
