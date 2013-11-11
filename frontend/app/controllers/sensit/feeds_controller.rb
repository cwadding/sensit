require_dependency "sensit/application_controller"

module Sensit
  class FeedsController < ApplicationController
    before_action :set_feed, only: [:show, :edit, :update, :destroy]

    # GET /feeds
    def index
      @feeds = Feed.all
    end

    # GET /feeds/1
    def show
    end

    # GET /feeds/new
    def new
      @feed = Feed.new
    end

    # GET /feeds/1/edit
    def edit
    end

    # POST /feeds
    def create
      @feed = Feed.new(feed_params)

      if @feed.save
        redirect_to @feed, notice: 'Feed was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /feeds/1
    def update
      if @feed.update(feed_params)
        redirect_to @feed, notice: 'Feed was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /feeds/1
    def destroy
      @feed.destroy
      redirect_to feeds_url, notice: 'Feed was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed
        @feed = Feed.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def feed_params
        params.require(:feed).permit(:name)
      end
  end
end
