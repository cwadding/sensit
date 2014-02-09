# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sensit_topic_publication, :class => 'Topic::Publication' do
    host "MyString"
    port 1
    username "MyString"
    password "MyString"
    protocol "MyString"
    topic_id 1
    actions_mask 1
  end
end
