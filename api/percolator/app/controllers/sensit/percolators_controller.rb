require_dependency "sensit/api_controller"

module Sensit
  class PercolatorsController < ApiController
    respond_to :json
    # GET /percolators
    def index
      @percolators = Topic::Percolator.search(type: elastic_type_name, body: query_params)
      respond_with(@percolators)
    end

    # GET /percolators/1
    def show
      @percolator = Topic::Percolator.find(type: elastic_type_name, id: params[:id])
      respond_with(@percolator)
    end

    # POST /percolators
    def create
      @percolator = Topic::Percolator.new(percolator_params.merge!(type: elastic_type_name))
      if @percolator.save
        respond_with(@percolator,:status => 200, :template => "sensit/percolators/show")
      else
        render(:json => "{\"errors\":#{@percolator.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /percolators/1
    def update
      @percolator = Topic::Percolator.update(percolator_params.merge!(type: elastic_type_name,:id => params[:id]))
      if @percolator.present? && @percolator.valid?
        respond_with(@percolator,:status => 200, :template => "sensit/percolators/show")
      else
        render(:json => "{\"errors\":#{@percolator.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /percolators/1
    def destroy
      elastic_client.delete(index: elastic_index_name, type: elastic_type_name, id: params[:id])
      head :status => 204
    end


    def elastic_index_name
      Rails.env.test? ? ELASTIC_SEARCH_INDEX_NAME : "_percolator"
    end

    def elastic_type_name
      Rails.env.test? ? ELASTIC_SEARCH_INDEX_TYPE : params[:topic_id].to_s
    end



    private

    def query_params
      params.permit(body: {query: {query_string: [:query]}})
    end
      # Use callbacks to share common setup or constraints between actions.
    def elastic_client
      @client ||= ::Elasticsearch::Client.new
    end
    # Only allow a trusted parameter "white list" through.
    def percolator_params
      params.require(:percolator).permit!#(:id, :body)
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
