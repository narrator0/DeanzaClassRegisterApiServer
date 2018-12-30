class Notification < ApplicationRecord
  serialize :data

  # relationships
  belongs_to :user

  def self.read_all
    update_all(read: true, read_at: Time.now.utc)
  end

  def read!
    update!(read: true, read_at: Time.now.utc)
  end
end
