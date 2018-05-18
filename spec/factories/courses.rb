FactoryBot.define do
  factory :course do
    crn { Faker::Number.number(10) }
    course 'PHYS 4A'
    department 'CIS'
    quarter 'M2018'

    transient do
      courses_count 2
    end

    after(:create) do |course, evaluator|
      create_list(:lecture, evaluator.courses_count, course: course)
    end
  end
end
