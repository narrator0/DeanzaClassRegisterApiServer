require 'rails_helper'

RSpec.describe Lecture, type: :model do
  # Association Test
  it { should belong_to(:course) }

  # Validation Test
  it { should validate_presence_of(:title) }

  describe 'start_time parsing' do
    let(:lecture_with_tba_times) { create(:lecture, :with_tba_times) }
    let(:lecture) { create(:lecture, times: '09:30 AM-10:20 AM') }

    it 'returns nil when times is TBA' do
      expect(lecture_with_tba_times.start_time).to eq(nil)
    end

    it 'returns 9:30' do
      expect(lecture.start_time).to eq(Time.parse('09:30 AM'))
    end
  end

  describe 'end_time parsing' do
    let(:lecture_with_tba_times) { create(:lecture, :with_tba_times) }
    let(:lecture) { create(:lecture, times: '09:30 AM-10:20 AM') }

    it 'returns nil when times is TBA' do
      expect(lecture_with_tba_times.end_time).to eq(nil)
    end

    it 'returns 10:20' do
      expect(lecture.end_time).to eq(Time.parse('10:20 AM'))
    end
  end
end
