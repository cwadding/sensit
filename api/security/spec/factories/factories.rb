FactoryGirl.define do

  factory :api_key, :class => Sensit::ApiKey do
    user_id 1
    name "my_api_key"
  end
end