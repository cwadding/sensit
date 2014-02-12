require_dependency "sensit/api_controller"

module Sensit
  class PublicationsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_publications, :read_application_publications]
    doorkeeper_for :create, :update, :destroy, :scopes => [:manage_any_publications, :manage_application_publications]

    respond_to :json, :xml
    # GET /publications
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into each publication
    def index
      joins = {:user_id => doorkeeper_token.resource_owner_id, :slug => params[:topic_id]}
      joins.merge!(:application_id => doorkeeper_token.application_id) unless has_scope?("read_any_publications")
      @publications = Topic::Publication.joins(:topic).where(:sensit_topics => joins).page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@publications)
    end

    # GET /publications/1
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into the desired publication
    def show
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_publications")
        raise ::ActiveRecord::RecordNotFound
      else
        @publication = scoped_owner("read_any_publications").topics.find(params[:topic_id]).publications.find(params[:id])
        respond_with(@publication)
      end
    end

    # POST /publications
    def create
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_publications")
        head :unauthorized
      else
        topic = scoped_owner("manage_any_publications").topics.find(params[:topic_id])
        @publication = topic.publications.build(publication_params)
        if @publication.save
          respond_with(@publication,:status => :created, :template => "sensit/publications/show")
        else
          render(:json => "{\"errors\":#{@publication.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /publications/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_publications")
        raise ::ActiveRecord::RecordNotFound
      else
        @publication = scoped_owner("manage_any_publications").topics.find(params[:topic_id]).publications.find(params[:id])
        if @publication.update(publication_params)
          respond_with(@publication,:status => :ok, :template => "sensit/publications/show")
        else
          render(:json => "{\"errors\":#{@publication.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /publications/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_publications")
        raise ::ActiveRecord::RecordNotFound
      else
        @publication = scoped_owner("manage_any_publications").topics.find(params[:topic_id]).publications.find(params[:id])
        @publication.destroy
        head :status => :no_content
      end
    end

    private

      # Only allow a trusted parameter "white list" through.
      def publication_params
        if params[:publication] && params[:publication].has_key?(:uri)
          params.require(:publication).permit(:uri)
        else
          params.require(:publication).permit(:host, :protocol, :username, :password, :port)
        end
      end



  end
end
