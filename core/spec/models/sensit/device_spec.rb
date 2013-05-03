require 'spec_helper'

module Sensit
  describe Device do
    it {should have_many :sensors}
  end
end
