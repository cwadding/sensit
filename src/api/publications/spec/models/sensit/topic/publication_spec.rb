require 'spec_helper'

module Sensit
	describe Topic::Publication do
		it { should validate_presence_of(:host) }
		it {should belong_to :topic}

		

	end
end
