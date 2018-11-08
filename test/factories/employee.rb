# frozen_string_literal: true

require "taiwanese_id_validator/twid_generator"

FactoryBot.define do
  factory :employee do
    name do
      Faker::Name.name
    end
    company_email do
      Faker::Internet.email
    end
    personal_email do
      Faker::Internet.email
    end
    id_number do
      TwidGenerator.generate
    end
  end
end
