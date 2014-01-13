require 'spec_helper'

module Sensit
  describe User do
    it {should have_many(:topics).dependent(:destroy)}
  end
end
