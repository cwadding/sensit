require 'spec_helper'

module Sensit
	describe Topic do
		it {should have_many(:publications).dependent(:destroy)}
	end
end
