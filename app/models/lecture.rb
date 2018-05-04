class Lecture < ApplicationRecord
  # relations
  belongs_to :course

  # validations
  validates_presence_of :title
end
