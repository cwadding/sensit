# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, :class => Sensit::User do
    sequence :name do |n|
      "Company#{n}"
    end
  end

  factory :facet, :class => Sensit::Topic::Report::Facet do
    sequence :name do |n|
      "Facet#{n}"
    end
    query ({ :terms => { :field => "value1"}})
    report
  end

  factory :report, :class => Sensit::Topic::Report do
    sequence :name do |n|
      "Report#{n}"
    end
    query ({:match_all => {}})
    topic
    after(:create) do |report, evaluator|
      key_arr = []
      FactoryGirl.create(:facet, :report => report, name: "#{evaluator.name}facet")
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
