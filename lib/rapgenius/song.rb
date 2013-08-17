# encoding: utf-8
module RapGenius
  class Song
    include RapGenius::Scraper

    def initialize(path)
      self.url = path
    end

    def artist
      document.css('.song_title a').text
    end

    def title
      document.css('.edit_song_description i').text
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
          line: a.text
        )
      end
    end


  end
end