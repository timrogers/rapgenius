# encoding: utf-8
module RapGenius
  class Song
    include RapGenius::Client
    attr_reader :id

    def self.find(id)
      self.new(id: id).tap { |song| song.document }
    end

    def initialize(kwargs = {})
      @id = kwargs.delete(:id)
      @artist = kwargs.delete(:artist)
      @title  = kwargs.delete(:title)
      self.url = "songs/#{@id}"
    end

    def response
      document["response"]["song"]
    end

    def artist
      @artist ||= Artist.new(
        name: response["primary_artist"]["name"],
        id: response["primary_artist"]["id"],
        type: :primary
      )
    end

    def featured_artists
      @featured_artists ||= response["featured_artists"].map do |artist|
        Artist.new(
          name: artist["name"],
          id: artist["id"],
          type: :featured
        )
      end
    end

    def url
      response["url"]
    end

    def producer_artists
      @producer_artists ||= response["producer_artists"].map do |artist|
        Artist.new(
          name: artist["name"],
          id: artist["id"],
          type: :producer
        )
      end
    end

    def artists
      [artist] + featured_artists + producer_artists
    end

    def title
      @title ||= response["title"]
    end

    def description
      @description ||= document["response"]["song"]["description"]["plain"]
    end

    def images
      @images ||= keys_with_images.map do |key|
        node = response[key]
        if node.is_a? Array
          node.map { |subnode| subnode["image_url"] }
        elsif node.is_a? Hash
          node["image_url"]
        else
          return
        end
      end.flatten
    end

    def pyongs
      response["pyongs_count"]
    end

    def hot?
      response["stats"]["hot"]
    end

    def views
      response["stats"]["pageviews"]
    end

    def concurrent_viewers
      response["stats"]["concurrents"]
    end

    def media
      response["media"].map do |m|
        Media.new(type: m["type"], provider: m["provider"], url: m["url"])
      end
    end

    def lines
      @lines ||= response["lyrics"]["dom"]["children"].map do |node|
        parse_lines(node)
      end.flatten.compact
    end

    private

    def parse_lines(node)
      if node.is_a?(Array)
        node.map { |subnode| parse_lines(subnode) }
      elsif node.is_a?(String)
        Line.new(
          song: Song.new(id: @id),
          lyric: node
        )
      elsif node.is_a?(Hash) && node["tag"] == "p"
        parse_lines(node["children"])
      elsif node.is_a?(Hash) && node["tag"] == "a"
        Line.new(
          song: Song.new(id: @id),
          lyric: node["children"].select {|l| l.is_a? String }.join("\n"),
          id: node["data"]["id"]
        )
      else
        return
      end
    end

    def keys_with_images
      %w{featured_artists producer_artists primary_artist}
    end

  end
end
