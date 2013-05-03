require_dependency "sensit/feed/application_controller"

module Sensit
  class Feed::StreamsController < ApplicationController
    before_action :set_feed_stream, only: [:show, :edit, :update, :destroy]

    # GET /feed/streams
    def index
      @feed_streams = Feed::Stream.all
    end

    # GET /feed/streams/1
    def show
    end

    # GET /feed/streams/new
    def new
      @feed_stream = Feed::Stream.new
    end

    # GET /feed/streams/1/edit
    def edit
    end

    # POST /feed/streams
    def create
      @feed_stream = Feed::Stream.new(feed_stream_params)

      if @feed_stream.save
        redirect_to @feed_stream, notice: 'Stream was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /feed/streams/1
    def update
      if @feed_stream.update(feed_stream_params)
        redirect_to @feed_stream, notice: 'Stream was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /feed/streams/1
    def destroy
      @feed_stream.destroy
      redirect_to feed_streams_url, notice: 'Stream was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_feed_stream
        @feed_stream = Feed::Stream.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def feed_stream_params
        params.require(:feed_stream).permit(:unit_id, :min_value, :max_value, :start_value)
      end
  end
end
