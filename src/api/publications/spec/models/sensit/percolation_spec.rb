require 'spec_helper'

module Sensit
	describe Percolation do
		it {should belong_to :rule}
		it {should belong_to :publication}
	end
end
