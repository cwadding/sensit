# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, :class => Sensit::User do
    name ELASTIC_INDEX_NAME
  end

  factory :application, :class => ::Doorkeeper::Application do
    sequence :name do |n|
      "Application#{n}"
    end
    redirect_uri OAUTH2_REDIRECT_URI
    # secret "95b63199f75e780fb787549a9551582878181afd15db19c3835daafb6a265ca6"
    # uid "e072c008ab1f1c99b91a503f8e038836e1e5451f843c5443f29eccc27f1a7d63"
  end

  factory :access_grant, :class => ::Doorkeeper::AccessGrant do
    resource_owner_id 1
    expires_in 600000
    redirect_uri OAUTH2_REDIRECT_URI
    scopes ""
    application 
  end

	factory :topic, :class => Sensit::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end
    user
    application
    factory :topic_with_feeds do

      ignore do
        feeds_count 3
      end
      
      after(:create) do |topic, evaluator|
        key_arr = []
        evaluator.feeds_count.times do |i|
          client = ::Elasticsearch::Client.new
          Sensit::Topic::Feed.create({index: topic.user.name, type: topic.to_param, at: Time.now, :tz => "UTC", values: {value1: i}})
          client.indices.refresh(:index => topic.user.name)
        end
      end
    end
  end
end