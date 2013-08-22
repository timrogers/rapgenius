require 'nokogiri'
require 'httparty'

module RapGenius
  module Scraper
    # Custom HTTParty parser that parses the returned body with Nokogiri
    class NokogiriParser < HTTParty::Parser
      SupportedFormats.merge!('text/html' => :html)

      def html
        Nokogiri::HTML(body)
      end
    end

    # HTTParty client
    #
    # Sets some useful defaults for all of our requests.
    #
    # See Scraper#fetch
    class Client
      include HTTParty

      format   :html
      parser   NokogiriParser
      base_uri 'http://rapgenius.com'
      headers  'User-Agent' => "rapgenius.rb v#{RapGenius::VERSION}"
    end

    BASE_URL = Client.base_uri + "/".freeze

    attr_reader :url

    def url=(url)
      unless url =~ /^https?:\/\//
        @url = BASE_URL + url
      else
        @url = url
      end
    end

    def document
      @document ||= fetch(@url)
    end

    private

    def fetch(url)
      response = Client.get(url)

      if response.code != 200
        raise ScraperError, "Received a #{response.code} HTTP response"
      end

      response.parsed_response
    end
  end
end
