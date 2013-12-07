require_dependency "sensit/api_controller"

module Sensit
  class ReportsController < ApiController
    before_action :set_report, only: [:show, :update, :destroy]
    respond_to :json
    # GET /reports
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into each report
    def index
      @reports = Topic::Report.where(:topic_id => params[:topic_id])
      respond_with(@reports)
    end

    # GET /reports/1
    # returns the name and query along with the results of the query
    # accepts additional parameters which will be merged into the desired report
    def show
      respond_with(@report)
    end

    # POST /reports
    def create
      topic = Topic.find(params[:topic_id])
      @report = topic.reports.build(report_params)

      if @report.save
        respond_with(@report,:status => 200, :template => "sensit/reports/show")
      else
        render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # PATCH/PUT /reports/1
    def update
      if @report.update(report_params)
        respond_with(@report,:status => 200, :template => "sensit/reports/show")
      else
        render(:json => "{\"errors\":#{@report.errors.to_json}}", :status => :unprocessable_entity)
      end
    end

    # DELETE /reports/1
    def destroy
      @report.destroy
      head :status => 204
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_report
        @report = Topic::Report.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def report_params

        params.require(:report).permit(:name, :query => {:statistical => [:field, :fields, :script, :params], :terms => [:field, :size, :order], :histogram => [:field, :interval, :time_interval, :key_field, :value_field, :key_script, :value_script, :params]})
      end
  end
end
