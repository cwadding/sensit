require 'spec_helper'

module Sensit
  describe Topic::Report::Facet do
    it {should belong_to :report}
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:report_id) }

    it { should validate_presence_of(:body) }
  end
end
