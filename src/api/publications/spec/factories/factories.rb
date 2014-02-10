# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

	factory :publication, :class => Sensit::Topic::Publication do
		protocol "mqtt"
		host "broker.cloudmqtt.com"
		actions_mask
		topic
	end

	factory :percolation, :class => 'Sensit::Percolation' do
		publication
		rule
	end
	
	factory :rule, :class => 'Sensit::Rule' do
		sequence :name do |n|
			"Rule#{n}"
		end
	end
end
