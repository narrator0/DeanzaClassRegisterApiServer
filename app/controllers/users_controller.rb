class UsersController < ApplicationController
  def create
    user = User.new sign_up_params

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user.to_json(except: :id), token: token }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
