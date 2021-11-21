# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    url { "https://#{Faker::Internet.domain_name}" }
    slug {}
    secret {}
  end
end
