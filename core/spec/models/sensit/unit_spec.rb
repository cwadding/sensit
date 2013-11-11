require 'spec_helper'

module Sensit
  describe Unit do
    it {should belong_to :group}
  	it {should belong_to :datatype}
  	it {should have_many :fields}
  end
end
