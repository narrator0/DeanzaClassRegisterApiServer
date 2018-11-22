require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association Test
  it { should have_many(:lectures).dependent(:destroy) }
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }
  it { should have_many(:notification_subscribers).through(:notify_subscriptions).source(:user) }
  it { should have_many(:like_subscribers).through(:likes).source(:user) }
  it { should have_many(:calendar_subscribers).through(:calendars).source(:user) }

  # Validation Test
  it { should validate_presence_of(:crn) }
  it { should validate_presence_of(:course) }

  # Enum Test
  it do
    should define_enum_for(:status).
           with_values([:Open, :Waitlist, :Full])
  end
end
