require 'rails_helper'

RSpec.describe CourseStatusUpdateNotification, type: :model do
  it { validate_presence_of(:message) }
  it { should belong_to(:user) }

  describe '#read!' do
    it 'updates `read` to true and sets `read_at`' do
      user = create(:user)

      CourseStatusUpdateNotification.create(user: user).read!

      expect(CourseStatusUpdateNotification.last.read).to be_truthy
      expect(CourseStatusUpdateNotification.last.read_at).not_to be_falsy
    end
  end
end
