# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :data_point, :class => Sensit::Device::Sensor::DataPoint do
		sensor_id 1
		value "9.99"
    end
end
