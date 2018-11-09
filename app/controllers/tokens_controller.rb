class TokensController < ApplicationController
  def create
    auth_token = AuthenticateUser.authenticate(user_params[:email], user_params[:password])
    render json: { auth_token: auth_token }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
