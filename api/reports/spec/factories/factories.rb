# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :facet, :class => Sensit::Topic::Report::Facet do
    sequence :name do |n|
      "Facet#{n}"
    end
    body ({ :statistical => { :field => "num1"}})
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
      FactoryGirl.create(:facet, :report => report)
    end
  end

	factory :topic, :class => Sensit::Topic do
		sequence :name do |n|
			"Topic#{n}"
		end
	end

end
