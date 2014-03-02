require_dependency "sensit/api_controller"

module Sensit
  class ReportsController < ApiController
    doorkeeper_for :index, :show, :scopes => [:read_any_reports, :read_application_reports]
    doorkeeper_for :create, :update, :destroy, :scopes => [:manage_any_reports, :manage_application_reports]

    respond_to :json, :xml
    # GET /reports
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into each report
    def index
      joins = {:user_id => doorkeeper_token.resource_owner_id, :slug => params[:topic_id]}
      joins.merge!(:application_id => doorkeeper_token.application_id) unless has_scope?("read_any_reports")
      @reports = Topic::Report.joins(:topic).where(:sensit_topics => joins).page(params[:page] || 1).per(params[:per] || 10)
      respond_with(@reports)
    end

    # GET /reports/1
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into the desired report
    def show
      if attempting_to_access_topic_from_another_application_without_privilage("read_any_reports")
        raise ::ActiveRecord::RecordNotFound
      else
        @report = scoped_owner("read_any_reports").topics.find(params[:topic_id]).reports.find(params[:id])
        results = @report.results
        respond_with(@report)
      end
    end

    # POST /reports
    def create
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_reports")
        head :unauthorized
      else
        topic = scoped_owner("manage_any_reports").topics.find(params[:topic_id])
        @report = topic.reports.build(report_params)
        aggregations_params.each do |aggregation_params|
          @report.aggregations.build(aggregation_params)
        end
        if @report.save
          respond_with(@report,:status => :created, :template => "sensit/reports/show")
        else
          render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # PATCH/PUT /reports/1
    def update
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_reports")
        raise ::ActiveRecord::RecordNotFound
      else
        @report = scoped_owner("manage_any_reports").topics.find(params[:topic_id]).reports.find(params[:id])

        (params[:report][:aggregations] || []).each do |aggregation_params|
          aggregation = @report.aggregations.where( name: aggregation_params[:name]).first || nil
          aggregation.update(query: aggregation_params[:query]) unless aggregation.blank?
        end

        if @report.update(report_params)
          respond_with(@report,:status => :ok, :template => "sensit/reports/show")
        else
          render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
        end
      end
    end

    # DELETE /reports/1
    def destroy
      if attempting_to_access_topic_from_another_application_without_privilage("manage_any_reports")
        raise ::ActiveRecord::RecordNotFound
      else
        @report = scoped_owner("manage_any_reports").topics.find(params[:topic_id]).reports.find(params[:id])
        @report.destroy
        head :status => :no_content
      end
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
      def aggregations_params
        # fields = Topic::Field.joins(:topic).where(:sensit_topics => {:slug => params[:topic_id]}).map(&:key)
        params.require(:report).require(:aggregations).map do |aggregation|
          type = aggregation.delete(:type)
          aggregation[:kind] = type
          aggregation.tap do |whitelisted|
            whitelisted[:name] = aggregation[:name] if aggregation.has_key?(:name)
            whitelisted[:kind] = aggregation[:kind]
            whitelisted[:query] = aggregation[:query] if aggregation.has_key?(:query)
          end
        end
      end



  end
end
