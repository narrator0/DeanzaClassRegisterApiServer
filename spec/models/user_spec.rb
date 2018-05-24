require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:subscribtions) }
  it { should have_many(:subscribed_courses).through(:subscribtions).source(:course) }
end
