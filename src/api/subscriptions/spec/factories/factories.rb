# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :subscription, :class => Sensit::Subscription do
    sequence :name do |n|
      "Subscription#{n}"
    end
	protocol "mqtt"
	host "broker.cloudmqtt.com"
    user
    application
  end
  
end
