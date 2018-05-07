json.total @courses.length
json.data @courses do |course|
  json.(course, :crn, :course, :department)
  json.lectures course.lectures do |lecture|
    json.(lecture, :title, :days, :times, :instructor, :location)
  end
end
