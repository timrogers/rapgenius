module RapGenius
  class Media
    attr_reader :type, :url, :provider

    def initialize(kwargs)
      @type = kwargs.delete(:type)
      @url = kwargs.delete(:url)
      @provider = kwargs.delete(:provider)
    end
  end
end
