module Sensit
  class Percolation < ActiveRecord::Base
  	belongs_to :rule, foreign_key: "rule_id"
  	belongs_to :publication, foreign_key: "publication_id"
  end
end
