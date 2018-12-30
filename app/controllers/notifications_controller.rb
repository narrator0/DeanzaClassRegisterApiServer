class NotificationsController < ApplicationController
  before_action :authorize_request

  def read
    current_user.notifications.find(params[:id]).read!
    head :no_content
  end

  def read_all
    current_user.notifications.read_all
  end
end
