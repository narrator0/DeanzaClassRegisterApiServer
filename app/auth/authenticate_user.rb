class AuthenticateUser
  def self.authenticate(email, password)
    user = User.find_by(email: email)

    if user && user.valid_password?(password)
      return JsonWebToken.encode(user_id: user.id)
    else
      # raise Authentication error if credentials are invalid
      raise(ExceptionHandler::AuthenticationError, 'Invalid credentials!')
    end
  end
end
