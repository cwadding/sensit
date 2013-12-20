# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_group do
    sequence(:name) {|i| "MyGroup#{i}"}
    addresses_sentence "foo@bar.com, foobar@example.com, bar@foo.com"
    phone_numbers_sentence "(123) 456-7890, (098) 765-4321, (432) 764-1298"
  end
  
end
# == Schema Information
#
# Table name: email_groups
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

