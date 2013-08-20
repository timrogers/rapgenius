module RapGenius
  class Annotation
    include RapGenius::Scraper

    attr_reader :id, :song

    def self.find(id)
      self.new(id: id)
    end

    def initialize(kwargs)
      @id = kwargs.delete(:id)
      @song = kwargs.delete(:song)
      @lyric = kwargs.delete(:lyric)
      self.url = @id
    end

    def lyric
      @lyric ||= document.css('meta[property="rap_genius:referent"]').
        attr('content').to_s
    end

    def explanation
      @explanation ||= document.css('meta[property="rap_genius:body"]').
        attr('content').to_s
    end

    def song
      @song ||= Song.new(song_url)
    end

    def song_url
      @song_url ||= document.css('meta[property="rap_genius:song"]').
        attr('content').to_s
    end
  end
end
