class Course < ApplicationRecord
  # relations
  has_many :lectures, dependent: :destroy
end
