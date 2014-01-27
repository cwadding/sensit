# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :field, :class => Sensit::Topic::Field do
    sequence :name do |n|
      "Field#{n}"
    end
    sequence :key do |n|
      "key#{n}"
    end
    datatype 'string'
    topic
  end  

  factory :topic_with_feeds_and_fields, parent: :topic do
    ignore do
      sequence :field_keys do |n|
        ["key#{n}"]
      end
      feeds_count 3
    end
    after(:create) do |topic, evaluator|
      key_arr = []
      evaluator.field_keys.each do |key|
        field = topic.fields.where(key: key).first
        field = FactoryGirl.create(:field, topic: topic, key: key) if field.blank?
      end
      evaluator.feeds_count.times do |i|
        values = evaluator.field_keys.inject({}) {|h, key| h.merge!(key => i)}
        client = ::Elasticsearch::Client.new
        Sensit::Topic::Feed.create({index: topic.user.name, type: topic.to_param, at: Time.now, :tz => "UTC", values: values})
        client.indices.refresh(:index => topic.user.name)
      end
    end
  end

end
