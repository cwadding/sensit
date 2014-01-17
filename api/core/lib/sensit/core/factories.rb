# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, :class => Sensit::User do
    sequence :name do |n|
      "Company#{n}"
    end
  end

	factory :topic, :class => Sensit::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end
    user
    factory :topic_with_feeds do

      ignore do
        feeds_count 3
      end
      
      after(:create) do |topic, evaluator|
        key_arr = []
        evaluator.feeds_count.times do |i|
          client = ::Elasticsearch::Client.new
          Sensit::Topic::Feed.create({index: topic.user.to_param, type: topic.to_param, at: Time.now, :tz => "UTC", values: {value1: i}})
          client.indices.refresh(:index => topic.user.to_param)
        end
      end
    end
  end
end