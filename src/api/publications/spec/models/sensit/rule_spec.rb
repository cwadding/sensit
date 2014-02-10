require 'spec_helper'

module Sensit
	describe Rule do
		it {should have_many(:percolations).dependent(:destroy)}
		it {should have_many(:publications).through(:percolations)}
		it { should validate_presence_of(:name) }
		it { should validate_uniqueness_of(:name) }
	end
end
