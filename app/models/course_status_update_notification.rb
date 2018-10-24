class CourseStatusUpdateNotification < Notification
  def course_id
    self.data ? self.data[:course_id] : nil
  end

  def course_id=(id)
    self.data ? self.data[:course_id] = id : self.data = { course_id: id }
  end

  def course
    Course.find(self.course_id)
  end
end
