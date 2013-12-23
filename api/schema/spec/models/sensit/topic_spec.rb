require 'spec_helper'

module Sensit
  describe Topic do
    it {should have_many(:fields).dependent(:destroy)}
  end
end
