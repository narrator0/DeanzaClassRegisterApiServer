require 'rails_helper'

RSpec.describe Course, type: :model do
  # Association Test
  it { should have_many(:lectures).dependent(:destroy) }
end
