class Notification < ApplicationRecord
  serialize :data

  # relationships
  belongs_to :user

  def read!
    update!(read: true, read_at: Time.now.utc)
  end
end
