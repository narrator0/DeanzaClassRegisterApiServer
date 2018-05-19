class TokensController < ApplicationController
  def create
    auth_token = AuthenticateUser.authenticate(auth_params[:email], auth_params[:password])
    render json: { auth_token: auth_token }
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
