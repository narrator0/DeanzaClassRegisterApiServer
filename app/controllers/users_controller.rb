class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def create
    user = User.new user_params

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user, token: token }.to_json, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @current_user.update(user_params)
      render json: { user: @current_user }.to_json, status: :accepted
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
