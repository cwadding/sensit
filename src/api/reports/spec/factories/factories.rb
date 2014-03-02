# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :facet, :class => Sensit::Topic::Report::Facet do
    sequence :name do |n|
      "Facet#{n}"
    end
    kind "terms"
    query ({ :field => "value1"})
    report
  end

# Read about factories at https://github.com/thoughtbot/factory_girl

  factory :aggregation, :class => Sensit::Topic::Report::Aggregation do
    sequence :name do |n|
      "Aggregation#{n}"
    end
    kind "terms"
    query ({ :field => "value1"})
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
      FactoryGirl.create(:aggregation, :report => report, name: "#{evaluator.name}aggregation")
    end
  end

end
