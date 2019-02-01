class UsersController < ApplicationController
  before_action :authorize_request, except: :create

  def update
    if @current_user.update(user_params)
      render json: { user: @current_user }.to_json, status: :accepted
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  def subscriptions
    render json: @current_user.subscribed_courses_crns(params[:type])
  end

  def notifications
    render json: @current_user.notifications
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
