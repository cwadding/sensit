require 'spec_helper'

module Sensit
  describe UnitGroup do
	it {should have_many :units}
  end
end
