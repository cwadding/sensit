# module Sensit
	module SubscribableOwner
		extend ::ActiveSupport::Concern
		included do
  			has_many :subscriptions, :dependent => :destroy, class_name: "Sensit::Subscription", foreign_key: "user_id"
		end
	end
# end