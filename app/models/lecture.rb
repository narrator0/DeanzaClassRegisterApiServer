class Lecture < ApplicationRecord
  # relations
  belongs_to :course

  # validations
  validates_presence_of :title

  # hooks
  after_commit :cache_lecture

  private

  def cache_lecture
    self.course.update(cached_lecture: self.course.lectures.first.attributes.slice('title', 'instructor'))
  end
end
