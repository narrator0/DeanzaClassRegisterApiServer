module RequestSpecHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  def response_token
    JsonWebToken.decode(json['auth_token'])
  end
end
