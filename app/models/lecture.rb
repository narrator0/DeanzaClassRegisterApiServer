class Lecture < ApplicationRecord
  # relations
  belongs_to :course

  # validations
  validates_presence_of :title

  # hooks
  after_commit :cache_lecture

  def start_time
    Time.parse times.scan(/[0-9]+:[0-9]+ [APM]+/)[0]
  end

  def end_time
    Time.parse times.scan(/[0-9]+:[0-9]+ [APM]+/)[1]
  end

  def conflict_with?(lecture)
    !(start_time > lecture.end_time || lecture.start_time > end_time)
  end

  private

  def cache_lecture
    self.course.update(cached_lecture: self.course.lectures.first.attributes.slice('title', 'instructor'))
  end
end
