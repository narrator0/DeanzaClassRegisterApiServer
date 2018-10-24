require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association Test
  it { should have_many(:lectures).dependent(:destroy) }
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  # Validation Test
  it { should validate_presence_of(:crn) }
  it { should validate_presence_of(:course) }

  # Enum Test
  it do
    should define_enum_for(:status).
           with_values([:Open, :Waitlist, :Full])
  end
end
