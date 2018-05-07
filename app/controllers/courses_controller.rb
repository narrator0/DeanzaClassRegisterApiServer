class CoursesController < ApplicationController
  def index
    @courses = Course.includes(:lectures)

    @courses = @courses.where(department: params[:dept]) if params[:dept].present?
  end
end
