class Lecture < ApplicationRecord
  # relations
  belongs_to :course

  # validations
  validates_presence_of :title

  # hooks
  after_commit :cache_lecture

  def start_time
    time_string = times.scan(/[0-9]+:[0-9]+ [APM]+/)[0]
    time_string && Time.parse(time_string)
  end

  def end_time
    time_string = times.scan(/[0-9]+:[0-9]+ [APM]+/)[1]
    time_string && Time.parse(time_string)
  end

  def online_course?
    times == 'TBA-TBA'
  end

  def parsed_days
    {
      monday: days.match?(/M/),
      tuesday: days.match?(/T/),
      wednesday: days.match?(/W/),
      thursday: days.match?(/R/),
      friday: days.match?(/F/),
    }
  end

  def conflict_with?(lecture)
    return false if self.online_course? || lecture.online_course?

    overlap_days = false
    parsed_days.each do |key, value|
      overlap_days = true if value && lecture.parsed_days[key]
    end
    return false unless overlap_days

    !(start_time > lecture.end_time || lecture.start_time > end_time)
  end

  private

  def cache_lecture
    # in case of delete, self.course.lectures could be nil
    if lecture = self.course.lectures.first
      self.course.update(cached_lecture: lecture.attributes.slice('title', 'instructor', 'days', 'times'))
    elsif self.course.persisted?
      self.course.update(cached_lecture: {})
    end
  end
end
