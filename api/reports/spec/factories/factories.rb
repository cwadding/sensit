# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :report, :class => Sensit::Topic::Report do
    sequence :name do |n|
      "Report#{n}"
    end
    query ({ :statistical => { :field => "num1"}})
  end

end
