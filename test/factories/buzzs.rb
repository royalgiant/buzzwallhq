FactoryBot.define do
  factory :buzz do
    url { "MyString" }
    wall { nil }
    thumbnail_url { "MyString" }
    user { nil }
    approved { false }
    buzz_term { nil }
  end
end
