# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sensit_user, :class => 'User' do
    email "MyString"
    password_digest "MyString"
  end
end
