require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:notify_subscriptions) }
  it { should have_many(:subscribe_courses).through(:notify_subscriptions).source(:course) }
  it { should have_many(:like_courses).through(:likes).source(:course) }
  it { should have_many(:calendar_courses).through(:calendars).source(:course) }
end
