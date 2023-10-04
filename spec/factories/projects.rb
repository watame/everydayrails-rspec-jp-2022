FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "A test project." }
    due_on { 1.week.from_now }
    # projectはownerというエイリアスが設定されている
    association :owner
  end
end
