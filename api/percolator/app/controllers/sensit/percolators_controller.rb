require_dependency "sensit/api_controller"

module Sensit
  class PercolatorsController < ApiController
    doorkeeper_for :index, :show,    :scopes => [:read_any_percolations, :read_application_percolations]
    doorkeeper_for :create,:update,  :scopes => [:write_any_percolations, :write_application_percolations]
    doorkeeper_for :destroy,  :scopes => [:delete_any_percolations, :delete_application_percolations]

    respond_to :json, :xml
    # GET /percolators
    def index
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_percolations")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        @percolators = Topic::Percolator.search(topic_id: params[:topic_id], user_id: elastic_index_name, body: {:query => {"match_all" => {  }}}, size: (params[:per] || 10), from: (params[:page] || 0) * (params[:per] || 10))
        respond_with(@percolators)
      end
    end

    # GET /percolators/1
    def show
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_percolations")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        @percolator = Topic::Percolator.find(topic_id: params[:topic_id], user_id: elastic_index_name, name: params[:id])
        respond_with(@percolator)
      end
    end

    # POST /percolators
    def create
      if attempting_to_access_topic_from_another_application_without_privilage("write_any_percolations")
          head :unauthorized
      else
        @percolator = Topic::Percolator.new(percolator_params.merge!(topic_id: params[:topic_id], user_id: elastic_index_name))
        if @percolator.save
          respond_with(@percolator,:status => :created, :template => "sensit/percolators/show")
        else
          render(:json => "{\"errors\":#{@percolator.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /percolators/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("write_any_percolations")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else 
        @percolator = Topic::Percolator.update(percolator_params.merge!(topic_id: params[:topic_id], user_id: elastic_index_name,:name => params[:id]))
        if @percolator.present? && @percolator.valid?
          respond_with(@percolator,:status => :ok, :template => "sensit/percolators/show")
        else
          render(:json => "{\"errors\":#{@percolator.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /percolators/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("delete_any_percolations")
        raise ::Elasticsearch::Transport::Transport::Errors::NotFound
      else
        Topic::Percolator.destroy(topic_id: params[:topic_id], user_id: elastic_index_name, name: params[:id])
        head :status => :no_content
      end
    end

    private

    def attempting_to_access_topic_from_another_application_without_privilage(scope)
      (!has_scope?(scope) && !current_application.topics.map(&:slug).include?(params[:topic_id].to_s)) || !current_user.topics.map(&:slug).include?(params[:topic_id].to_s)
    end

      # Use callbacks to share common setup or constraints between actions.
    def elastic_client
      @client ||= ::Elasticsearch::Client.new
    end

    def query_params
      params.require(:percolator).require(:query).permit!
    end
    # Only allow a trusted parameter "white list" through.

    def percolator_params
        params.require(:percolator).permit(:name).tap do |whitelisted|
          whitelisted[:query] = params[:percolator][:query] if params[:percolator].has_key?(:query)
        end

      # (:id, 
      #   body: {
      #     query: {
      #       bool: {
      #         :minimum_should_match => [],
      #         :must => {:term => [:user,:tag], :range => {:age => [:from, :to]}}, 
      #         :must_not => {:term => [:user,:tag], :range => {:age => [:from, :to]}}, 
      #         :should => {:term => [:user,:tag], :range => {:age => [:from, :to]}}
      #       }, 
      #       multi_match:[:query, :use_dis_max, :fields => []], 
      #       query_string: [:query], 
      #       match: { 
      #         message: [:query, :type, :operator, :minimum_should_match, :zero_terms_query, :cutoff_frequency]
      #       },
      #       match_phrase:{
      #         :message => [:query, :analyzer]
      #       }, 
      #       match_phrase_prefix: {
      #         message:[:query, :max_expansions]
      #       }, 
      #       span_first:{
      #         match:[:span_term]
      #       }, 
      #       span_multi:{
      #         match:[:prefix]
      #       }, 
      #       span_near:[:clauses], 
      #       span_not:[:include, :exclude], 
      #       span_or:[:clauses], 
      #       span_term:[], 
      #       in: [], 
      #       terms: [], 
      #       term:[]
      #     }
      #   }
      # )
    end
  end
end
