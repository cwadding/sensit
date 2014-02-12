# module Sensit
	module SensibleOwner
		extend ::ActiveSupport::Concern
		included do
  			has_many :topics, :dependent => :destroy, class_name: "Sensit::Topic", foreign_key: "user_id"
    		validates :name, presence: true, uniqueness: true
    		has_many :oauth_applications, class_name: '::Doorkeeper::Application', as: :owner
		end
	end
# end