FactoryBot.define do
  factory :lecture do
    title { 'Physics for Scientists and Engineers: Mechanics' }
    days  { 'MTWRF··' }
    times { '09:30 AM-10:20 AM' }
    instructor { Faker::Name.name }
    location { 'S32' }
    course
  end
end
