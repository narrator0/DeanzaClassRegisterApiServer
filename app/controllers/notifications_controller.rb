class NotificationsController < ApplicationController
  before_action :authorize_request

  def read
    Notification.find(params[:id]).read!
    head :no_content
  end
end
