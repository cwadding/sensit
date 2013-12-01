# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :subscription, :class => Sensit::Topic::Subscription do
    sequence :name do |n|
      "Subscription#{n}"
    end
    host "127.0.0.1"
  end

  factory :api_key, :class => Sensit::ApiKey do
    user_id 1
    name "my_api_key"
  end

  factory :datatype, :class => Sensit::Datatype do
    name "integer"
  end

  factory :unit, :class => Sensit::Unit do
    name "meters"
    abbr "m"
    datatype
    group
  end

  factory :group, :class => Sensit::UnitGroup do
    name "metric measurement"
  end
  
  # factory :data_row, :class => Sensit::Topic::Feed::DataRow do
  #   sequence :key do |n|
  #     "key#{n}"
  #   end
  #   sequence :value do |n|
  #     "Value#{n}"
  #   end
  # end
  
  # factory :feed, :class => Sensit::Topic::Feed do
  #   at Time.now
  #   ignore do
  #     rows_count 1
  #   end
  #   # after(:create) do |feed, evaluator|
  #     # FactoryGirl.create_list(:data_row, evaluator.rows_count , feed: feed)
  #   # end
  # end

  factory :field, :class => Sensit::Topic::Field do
    sequence :name do |n|
      "Field#{n}"
    end
    sequence :key do |n|
      "key#{n}"
    end
    unit
  end  

	factory :topic, :class => Sensit::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end

    ignore do
      fields_count 1
    end

    ignore do
      feeds_count 1
    end

    api_key

    factory :topic_with_feeds_and_fields do
      after(:create) do |topic, evaluator|
        key_arr = []
        evaluator.fields_count.times do |i|
          field = FactoryGirl.create(:field, topic: topic)
          key_arr << field.key
        end
        evaluator.feeds_count.times do |i|
          values = key_arr.inject({}) {|h, key| h.merge!(key => i)}
          client = ::Elasticsearch::Client.new
          Sensit::Topic::Feed.create({:topic_id => topic.id, index: ELASTIC_SEARCH_INDEX_NAME, type: ELASTIC_SEARCH_INDEX_TYPE, at: Time.now, values: values})
          client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
        end
      end
    end
  end

end
