class JsonWebToken
  SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload, expire = 24.hours.from_now)
    payload[:expire] = expire.to_i
    JWT.encode payload, SECRET
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    # raise custom error to be handled by custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end
end
