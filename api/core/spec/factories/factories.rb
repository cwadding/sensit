# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

	factory :topic, :class => Sensit::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end

    factory :topic_with_feeds do

      ignore do
        feeds_count 1
      end
      
      after(:create) do |topic, evaluator|
        key_arr = []
        evaluator.feeds_count.times do |i|
          client = ::Elasticsearch::Client.new
          Sensit::Topic::Feed.create({index: ELASTIC_SEARCH_INDEX_NAME, type: ELASTIC_SEARCH_INDEX_TYPE, at: Time.now, :tz => "UTC", values: {value1: i}})
          client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
        end
      end
    end
  end

end
