require 'spec_helper'

module Sensit
  describe Node do
    it {should have_many :topics}
  end
end
