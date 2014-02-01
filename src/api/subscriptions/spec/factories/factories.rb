# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :subscription, :class => Sensit::Topic::Subscription do
    sequence :name do |n|
      "Subscription#{n}"
    end
    host "127.0.0.1"
    topic
  end
  
end
