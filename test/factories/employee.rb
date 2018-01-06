# frozen_string_literal: true
FactoryBot.define do
  factory :fulltime_employee do
    name { "Nao" }
    type { "fulltime" }
    start_date { "2015-05-13" }
    end_date { "2017-03-17" }
  end
end
