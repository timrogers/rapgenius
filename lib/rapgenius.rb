require 'rapgenius/version'
require 'rapgenius/client'
require 'rapgenius/line'
require 'rapgenius/song'
require 'rapgenius/artist'
require 'rapgenius/media'
require 'rapgenius/exceptions'

module RapGenius
  extend RapGenius::Client

  def self.search(query, options = {})
    response = fetch(build_api_url("/search"), { q: query }.merge(options))



    response["response"]["hits"].map do |song|
      result = song["result"]

      Song.new(
        id: result["id"],
        name: result["name"],
        artist: Artist.new(
          id: result["primary_artist"]["id"],
          name: result["primary_artist"]["name"],
          type: :primary
        ),
        title: result["title"]
      )
    end
  end

  def self.search_by_artist(query)
    self.search(query, field: "primary_artist_name")
  end

  def self.search_by_title(query)
    self.search(query, field: "title")
  end

  def self.search_by_lyrics(query)
    self.search(query, field: "lyrics")
  end
end
