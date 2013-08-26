# encoding: utf-8
module RapGenius
  class Song
    include RapGenius::Scraper

    def self.find(path)
      self.new(path)
    end

    # Search for a song
    #
    # query - Song to search for
    #
    # Returns an Array of Song objects.
    def self.search(query)
      results = Client.search(query)

      results.split("\n").map do |song|
        info, link, id = song.split('|')
        artist, title  = info.force_encoding('UTF-8').split(' – ')

        new(link, artist: artist, title: title)
      end
    end

    def initialize(path, kwargs = {})
      self.url = path

      @artist = kwargs.delete(:artist)
      @title  = kwargs.delete(:title)
    end

    def artist
      @artist ||= document.css('.song_title a').text
    end

    def title
      @title ||= document.css('.edit_song_description i').text
    end

    def description
      document.css('.description_body').text
    end

    def images
      document.css('meta[property="og:image"]').
        map { |meta| meta.attr('content') }
    end

    def full_artist
      document.css('meta[property="og:title"]').attr('content').to_s.
        split(" – ").first
    end

    def annotations
      @annotations ||= document.css('.lyrics a').map do |a|
        Annotation.new(
          id: a.attr('data-id').to_s,
          song: self,
          lyric: a.text
        )
      end
    end
  end
end
