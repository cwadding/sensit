FactoryGirl.define do

  factory :unit, :class => Sensit::Unit do
    name "meters"
    abbr "m"
    datatype
    group
  end

  factory :group, :class => Sensit::UnitGroup do
    name "metric measurement"
  end
end