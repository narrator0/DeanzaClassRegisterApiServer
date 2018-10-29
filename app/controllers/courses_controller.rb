class CoursesController < ApplicationController
  def index
    json = Rails.cache.fetch(request.original_url) do
      quarter = params[:quarter] || Rails.application.credentials.quarter

      courses = Course.select(:id, :crn, :course, :department, :status, :cached_lecture)
                      .where_if_present(department: params[:dept])
                      .where(quarter: quarter)
                      .order(order)

      {
        total: courses.length,
        data: courses
      }.to_json
    end

    render json: json
  end

  def show
    course = Course.find(params[:id])
    render json: course.to_json(include: :lectures, except: :cached_lecture)
  end

  private

  # manually filter using case
  # to avoid sql injection
  def order
    case params[:sortBy]
    when 'crn'
      'crn'
    when 'course'
      'course'
    else
      'id'
    end
  end
end
