# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :sensor, :class => Sensit::Device::Sensor do
		unit_id 1
		min_value 2
		max_value 3
		start_value 4
		device_id 5
    end
end
