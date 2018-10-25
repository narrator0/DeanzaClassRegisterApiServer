FactoryBot.define do
  factory :course_status_update_notification do
    message 'test'
    association :user
  end
end

