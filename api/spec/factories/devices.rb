# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :device, :class => Sensit::Device do
        title "Title"
        url "Url"
        status "Status"
        description "Description"
        icon "Icon"
        user_id 1
        location_id 2
    end
end
