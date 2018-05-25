class SubscribtionsController < ApplicationController
  before_action :authorize_request

  def subscribe
    @current_user.subscribe params[:crn]
    render json: @current_user.subscribed_course_ids, status: 200
  end
end
