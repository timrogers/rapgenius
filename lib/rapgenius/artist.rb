# encoding: utf-8
module RapGenius
  class Artist
    include RapGenius::Client

    def self.find(id)
      self.new(id: id).tap { |artist| artist.document }
    end

    def initialize(kwargs = {})
      @id = kwargs.delete(:id)
      @name = kwargs.delete(:name)
      @type = kwargs.delete(:type)
      self.url = "artists/#{@id}"
    end

    def response
      document["response"]["artist"]
    end

    def name
      @name ||= response["name"]
    end

    def image
      @image ||= response["image_url"]
    end

    def url
      response["url"]
    end

    def description
      @description ||= response["description"]["dom"]["children"].map do |node|
        parse_description(node)
      end.flatten.join("")
    end

    # You seem to be able to load 25 songs at a time for an artist. I haven't
    # found a way to vary the number you get back from the query, but you can
    # paginate through in blocks of 25 songs.
    def songs(options = {page: 1})
      songs_url = "/artists/#{@id}/songs/?page=#{options[:page]}"
      
      fetch(songs_url)["response"]["songs"].map do |song|
        Song.new(
          artist: Artist.new(
            name: song["primary_artist"]["name"],
            id: song["primary_artist"]["id"],
            type: :primary
          ),
          title: song["title"],
          id: song["id"]
        )
      end
    end

  end
end
