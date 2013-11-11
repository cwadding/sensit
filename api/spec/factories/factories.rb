# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

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
  
  factory :data_row, :class => Sensit::Node::Topic::Feed::DataRow do
    sequence :key do |n|
      "key#{n}"
    end
    sequence :value do |n|
      "Value#{n}"
    end
  end
  
  factory :feed, :class => Sensit::Node::Topic::Feed do
    at Time.now
    ignore do
      rows_count 1
    end
    after(:create) do |feed, evaluator|
      FactoryGirl.create_list(:data_row, evaluator.rows_count , feed: feed)
    end
  end

  factory :field, :class => Sensit::Node::Topic::Field do
    sequence :name do |n|
      "Field#{n}"
    end
    sequence :key do |n|
      "key#{n}"
    end
    unit
  end  

	factory :topic, :class => Sensit::Node::Topic do
	  sequence :name do |n|
	    "Topic#{n}"
	  end

    ignore do
      fields_count 1
    end

    ignore do
      feeds_count 1
    end    

    factory :topic_with_feeds_and_fields do
      after(:create) do |topic, evaluator|
        FactoryGirl.create(:field, topic: topic)
        FactoryGirl.create(:feed, topic: topic)
      end
    end
  end

  factory :node, :class => Sensit::Node do
    name "Title"
      
    # topics_count is declared as an ignored attribute and available in
    # attributes on the factory, as well as the callback via the evaluator
    ignore do
      topics_count 3
    end

    # the after(:create) yields two values; the node instance itself and the
    # evaluator, which stores all values from the factory, including ignored
    # attributes; `create_list`'s second argument is the number of records
    # to create and we make sure the node is associated properly to the topic

    factory :complete_node do
      after(:create) do |node, evaluator|
        FactoryGirl.create_list(:topic_with_feeds_and_fields, evaluator.topics_count, node: node)
      end
    end
  end
end
