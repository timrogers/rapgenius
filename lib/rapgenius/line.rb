module RapGenius
  class Line
    include RapGenius::Client

    attr_reader :id

    def self.find(id)
      self.new(id: id).tap { |line| line.document }
    end

    def initialize(kwargs)
      @id = kwargs.delete(:id)
      @song = kwargs.delete(:song)
      @lyric = kwargs.delete(:lyric)
      self.url = "referents/#{@id}" if @id
    end

    def response
      return nil unless @id
      document["response"]["referent"]
    end

    def lyric
      if @id
        @lyric ||= response["fragment"]
      else
        @lyric
      end
    end

    def annotated?
      !!@id
    end

    alias_method :explained?, :annotated?

    # A line can have multiple annotations, usually if it has a community one
    # and a verified one. Ideally, these would be encapsulated into an
    # Annotation class, but I don't have time for now.
    def explanations
      return nil unless @id
      @explanation ||= response["annotations"].map do |annotation|
        annotation["body"]["dom"]["children"].map do |node|
          parse_description(node)
        end.join("")
      end.flatten
    end

    alias_method :annotations, :explanations

    def song
      if @id
        @song ||= Song.find(response['song_id'])
      else
        @song
      end
    end
  end
end
