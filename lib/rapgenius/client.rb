require 'httparty'

module RapGenius
  module Client
    class << self
      attr_accessor :access_token
    end

    class HTTPClient
      include HTTParty

      format   :json
      base_uri 'https://api.rapgenius.com'
    end

    BASE_URL = HTTPClient.base_uri + "/".freeze
    PLAIN_TEXT_FORMAT = "plain".freeze
    DOM_TEXT_FORMAT = "dom".freeze

    attr_reader :text_format

    def url=(url)
      unless url =~ /^https?:\/\//
        @url = build_api_url(url)
      else
        @url = url
      end
    end

    def document
      @document ||= fetch(@url)
    end

    def fetch(url, params = {})
      response = HTTPClient.get(url, query: {
        text_format: "#{DOM_TEXT_FORMAT},#{PLAIN_TEXT_FORMAT}"
      }.merge(params), headers: {
        'Authorization' => "Bearer #{RapGenius::Client.access_token}",
        'User-Agent' => "rapgenius.rb v#{RapGenius::VERSION}"
      })

      case response.code
      when 404
        raise RapGenius::NotFoundError
      when 401
        raise RapGenius::AuthenticationError
      when 200
        return response.parsed_response
      else
        raise RapGenius::Error, "Received a #{response.code} HTTP response"
      end
    end

    private

    def build_api_url(path)
      BASE_URL + path.gsub(/^\//, '')
    end
  end
end
