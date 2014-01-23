# module Sensit
	module SensibleOwner
		extend ::ActiveSupport::Concern
		included do
  			has_many :topics, :dependent => :destroy, class_name: "Sensit::User"
    		validates :name, presence: true
		end
	end
# end