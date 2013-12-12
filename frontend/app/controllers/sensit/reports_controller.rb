require_dependency "sensit/application_controller"

module Sensit
  class ReportsController < ApplicationController
    # before_action :set_report, only: [:show, :edit, :update, :destroy]

    # GET /reports
    def index
      # @reports = Report.all
    end

    # GET /reports/1
    def show
    end

    # GET /reports/new
    def new
      @fields = []
      @fields << Node::Topic::Field.new(:key => "hello", :name => "Hello")
      @fields << Node::Topic::Field.new(:key => "foo", :name => "Foo")
      @fields << Node::Topic::Field.new(:key => "bar", :name => "Bar")
      # @report = Report.new
    end

    # GET /reports/1/edit
    def edit
    end

    # POST /reports
    def create
      # @report = Report.new(report_params)

      # if @report.save
      #   redirect_to @report, notice: 'Report was successfully created.'
      # else
      #   render action: 'new'
      # end
      redirect_to reports_url, notice: 'Report was successfully destroyed.'
    end

    # PATCH/PUT /reports/1
    def update
      # if @report.update(report_params)
      #   redirect_to @report, notice: 'Report was successfully updated.'
      # else
      #   render action: 'edit'
      # end
      redirect_to reports_url, notice: 'Report was successfully destroyed.'
    end

    # DELETE /reports/1
    def destroy
      # @report.destroy
      redirect_to reports_url, notice: 'Report was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      # def set_report
      #   @report = Report.find(params[:id])
      # end

      # Only allow a trusted parameter "white list" through.
      # def report_params
      #   params[:report]
      # end
  end
end
