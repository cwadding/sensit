module Sensit
  class Rule < ActiveRecord::Base
  	has_many :percolations, dependent: :destroy, foreign_key: "rule_id"
  	has_many :publications, through: :percolations

  	validates :name, presence: true, uniqueness: true

  end
end
