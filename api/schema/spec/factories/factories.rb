# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :api_key, :class => Sensit::ApiKey do
    user_id 1
    name "my_api_key"
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
    datatype 'string'
  end  

	factory :topic, :class => Sensit::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end

    ignore do
      sequence :field_keys do |n|
        ["key#{n}"]
      end
      feeds_count 1
    end

    api_key

    factory :topic_with_feeds_and_fields do
      after(:create) do |topic, evaluator|
        key_arr = []
        evaluator.field_keys.each do |key|
          field = topic.fields.where(key: key).first
          field = FactoryGirl.create(:field, topic: topic, key: key) if field.blank?
        end
        evaluator.feeds_count.times do |i|
          values = evaluator.field_keys.inject({}) {|h, key| h.merge!(key => i)}
          client = ::Elasticsearch::Client.new
          Sensit::Topic::Feed.create({:topic_id => topic.id, index: ELASTIC_SEARCH_INDEX_NAME, type: ELASTIC_SEARCH_INDEX_TYPE, at: Time.now, :tz => "UTC", values: values})
          client.indices.refresh(:index => ELASTIC_SEARCH_INDEX_NAME)
        end
      end
    end
  end

end
