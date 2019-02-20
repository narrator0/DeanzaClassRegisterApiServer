class Calendar < Subscription
  # validations
  validate :conflicts

  private

  def conflicts
    # user_id may be nil is rare cases
    return unless user

    user.calendar_courses.each do |c|
      if self.course.conflict_with? c
        errors.add(:lecture_times, "conflict with #{c.course}.")
      end
    end
  end
end
