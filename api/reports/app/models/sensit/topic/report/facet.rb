module Sensit
  class Topic::Report::Facet < ActiveRecord::Base
  	belongs_to :report
  	serialize :body, Hash
  	validates :name, presence: true, uniqueness: {scope: :report_id}
  	validates :body, presence: true
  end
end
