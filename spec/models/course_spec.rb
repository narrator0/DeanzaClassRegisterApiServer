require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association Test
  it { should have_many(:lectures).dependent(:destroy) }

  # Validation Test
  it { should validate_presence_of(:crn) }
  it { should validate_presence_of(:course) }
end
