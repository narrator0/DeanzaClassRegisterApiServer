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

  def conflict_with?(lecture)
    !(start_time > lecture.end_time || lecture.start_time > end_time)
  end

  private

  def cache_lecture
    self.course.update(cached_lecture: self.course.lectures.first.attributes.slice('title', 'instructor'))
  end
end
