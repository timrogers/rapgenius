require 'nokogiri'
require 'httparty'

module RapGenius
  module Scraper
    BASE_URL = "http://rapgenius.com/".freeze

    attr_reader :url


    def url=(url)
      if !(url =~ /^https?:\/\//)
        @url = "#{BASE_URL}#{url}" 
      else
        @url = url
      end
    end

    def document
      @document ||= Nokogiri::HTML(fetch(@url))
    end

    private
    def fetch(url)
      response = HTTParty.get(url)

      if response.code != 200
        raise ScraperError, "Received a #{response.code} HTTP response"
      end

      response.body
    end

  end
end