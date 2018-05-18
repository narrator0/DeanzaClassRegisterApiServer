class CoursesController < ApplicationController
  def index
    json = Rails.cache.fetch(request.original_url) do
      quarter = params[:quarter] || "M2018"

      courses = Course.includes(:lectures)
                      .where_if_present(department: params[:dept])
                      .where(quarter: quarter)

      {
        total: courses.length,
        data: courses
      }.to_json
    end

    render json: json
  end
end
