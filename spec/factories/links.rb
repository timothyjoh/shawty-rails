# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    url { "https://#{Faker::Internet.domain_name}" }
    slug { Faker::Alphanumeric.alphanumeric(number: 8) }
    secret { Faker::Alphanumeric.alphanumeric(number: 16) }
  end
end
