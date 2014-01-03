# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sensit_topic_report_facet, :class => 'Topic::Report::Facet' do
    name "MyString"
    body "MyText"
  end
end
