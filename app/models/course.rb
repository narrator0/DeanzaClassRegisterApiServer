class Course < ApplicationRecord
  # relations
  has_many :lectures, dependent: :destroy
  accepts_nested_attributes_for :lectures

  # validations
  validates_presence_of :crn, :course
end
