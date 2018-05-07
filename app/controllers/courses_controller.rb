class CoursesController < ApplicationController
  def index
    @courses = Course.includes(:lectures)
  end
end
