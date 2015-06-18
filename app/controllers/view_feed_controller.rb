class ViewFeedController < ApplicationController

  require 'open-uri'

  def index
    @errors = []
    @feeds = nil
    if params[:url]
      @feeds = Feedjira::Feed.fetch_and_parse params[:url], on_failure: lambda { |curl, err|  @errors << err[1]}
      if @feeds == 0
        @feeds = nil
      else
        @feeds.entries.sort_by!{|a| a.published.to_datetime}.reverse!
      end
    end
    puts @feeds.inspect
  end

  def get_image_url
    link = Hash.new
    image_link = Nokogiri::HTML(open(params[:feed_url])).css("div.caption.full-width img")[0]['src'] rescue nil
    link["link"] = image_link
    render json: nil,status: :unprocessable_entity and return if !image_link
    render json: link,status: :ok
  end
end
