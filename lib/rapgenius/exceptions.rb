module RapGenius
  class Error < StandardError
  end

  class NotFoundError < Error
  end

  class AuthenticationError < Error
  end
end
