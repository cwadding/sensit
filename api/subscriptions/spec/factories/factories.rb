# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, :class => Sensit::User do
    sequence :name do |n|
      "Company#{n}"
    end
  end

  factory :subscription, :class => Sensit::Topic::Subscription do
    sequence :name do |n|
      "Subscription#{n}"
    end
    host "127.0.0.1"
    topic
  end

	factory :topic, :class => Sensit::Topic do
		sequence :name do |n|
			"Topic#{n}"
		end
    user
	end

end
