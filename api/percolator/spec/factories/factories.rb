# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, :class => Sensit::User do
    sequence :name do |n|
      "Company#{n}"
    end
  end

end
