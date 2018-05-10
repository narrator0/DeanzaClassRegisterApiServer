class Course < ApplicationRecord
  # relations
  has_many :lectures, dependent: :destroy
  accepts_nested_attributes_for :lectures

  # validations
  validates_presence_of :crn, :course

  # callbacks
  after_commit :flush_cache

  # use scope because it chains even if
  # hash.first[1].present? is nil
  scope :where_if_present, -> (hash) {
    where(hash) if hash.first[1].present?
  }

  def as_json(*)
    super(include: :lectures)
  end

  private
  def flush_cache
    Rails.cache.clear
  end
end
