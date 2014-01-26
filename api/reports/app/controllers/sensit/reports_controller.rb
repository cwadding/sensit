require_dependency "sensit/api_controller"

module Sensit
  class ReportsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_reports, :read_application_reports]
    doorkeeper_for :create, :update, :scopes => [:write_any_reports, :write_application_reports]
    doorkeeper_for :destroy,  :scopes => [:delete_any_reports, :delete_application_reports]

    respond_to :json
    # GET /reports
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into each report
    def index
      # TODO  Also join with user
      if has_scope?("read_any_reports")
        @reports = Topic::Report.joins(:topic).where(:sensit_topics => {:slug => params[:topic_id]}).page(params[:page] || 1).per(params[:per] || 10)
      else
        @reports = Topic::Report.joins(:topic).where(:sensit_topics => {:application_id => doorkeeper_token.application_id}).page(params[:page] || 1).per(params[:per] || 10)
      end
      respond_with(@reports)
    end

    # GET /reports/1
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into the desired report
    def show
      @report = scoped_owner(:read_any_reports).topics.find(params[:topic_id]).reports.find(params[:id])
      results = @report.results
      respond_with(@report)
    end

    # POST /reports
    def create
      topic = scoped_owner(:write_any_reports).topics.find(params[:topic_id])
      @report = topic.reports.build(report_params)
      facets_params.each do |facet_params|
        @report.facets.build(facet_params)
      end
      if @report.save
        respond_with(@report,:status => :created, :template => "sensit/reports/show")
      else
        render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /reports/1
    def update
      @report = scoped_owner(:write_any_reports).topics.find(params[:topic_id]).reports.find(params[:id])

      (params[:report][:facets] || []).each do |facet_params|
        facet = @report.facets.where( name: facet_params[:name]).first || nil
        facet.update(query: facet_params[:query]) unless facet.blank?
      end

      if @report.update(report_params)
        respond_with(@report,:status => :ok, :template => "sensit/reports/show")
      else
        render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /reports/1
    def destroy
      @report = scoped_owner(:delete_any_reports).topics.find(params[:topic_id]).reports.find(params[:id])
      @report.destroy
      head :status => :no_content
    end

    private

      # Only allow a trusted parameter "white list" through.
      def report_params
        # fields = Topic::Field.joins(:topic).where(:sensit_topics => {:slug => params[:topic_id]}).map(&:key)
        params.require(:report).permit(:name).tap do |whitelisted|
          whitelisted[:query] = params[:report][:query] if params[:report].has_key?(:query)
        end
      end

      # Only allow a trusted parameter "white list" through.
      def facets_params
        # fields = Topic::Field.joins(:topic).where(:sensit_topics => {:slug => params[:topic_id]}).map(&:key)
        params.require(:report).require(:facets)#.permit!#(:name, :query, :facets)
        # (:name, 
        #   :query => {:match_all => {}},
        #   :facets => {
        #     :statistical => [:field, :fields, :script, :params],
        #     :terms => [:field, :size, :order], 
        #     :histogram => [:field, :interval, :time_interval, :key_field, :value_field, :key_script, :value_script, :params]
        #   }
        # )
      end



  end
end
