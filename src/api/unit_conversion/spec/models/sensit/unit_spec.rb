require 'spec_helper'

module Sensit
  describe Unit do
    it {should belong_to :group}
  	it {should have_many :fields}
  end
end
