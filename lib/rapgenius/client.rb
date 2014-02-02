require 'httparty'

module RapGenius
  module Client
    # HTTParty client
    #
    # Sets some useful defaults for all of our requests.
    #
    # See Scraper#fetch
    class HTTPClient
      include HTTParty

      format   :json
      base_uri 'https://api.rapgenius.com'
      headers  'User-Agent' => "rapgenius.rb v#{RapGenius::VERSION}"
    end

    BASE_URL = HTTPClient.base_uri + "/".freeze

    def url=(url)
      unless url =~ /^https?:\/\//
        @url = BASE_URL + url.gsub(/^\//, '')
      else
        @url = url
      end
    end

    def document
      @document ||= fetch(@url)
    end

    def fetch(url)
      response = HTTPClient.get(url)

      if response.code != 200
        if response.code == 404
          raise RapGenius::NotFoundError
        else
          raise RapGenius::Error, "Received a #{response.code} HTTP response"
        end
      end

      response.parsed_response
    end

    # Descriptions are formatted in an irritating way, encapsulating the
    # various kinds of HTML tag that can be included. This parses that
    # into text, but some content may be lost.
    def parse_description(node)
      if node.is_a? String
        node
      elsif node.is_a? Array
        node.map { |subnode| parse_description(subnode) }
      elsif node.is_a? Hash
        return unless node.key? "children"
        parse_description(node["children"])
      end
    end

  end
end
