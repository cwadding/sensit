require 'spec_helper'

module Sensit
  describe Topic do
    it {should have_many(:reports).dependent(:destroy)}
  end
end
