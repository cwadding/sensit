# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :report, :class => Sensit::Topic::Report do
    sequence :name do |n|
      "Report#{n}"
    end
    query ({:match_all => {}})
    facets ({ :statistical => { :field => "num1"}})
    topic
  end

	factory :topic, :class => Sensit::Topic do
		sequence :name do |n|
			"Topic#{n}"
		end
	end

end
