class Course < ApplicationRecord
  # relations
  has_many :lectures, dependent: :destroy

  # validations
  validates_presence_of :crn, :course
end
