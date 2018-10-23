require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribed_courses).through(:subscriptions).source(:course) }
end
