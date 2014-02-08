# module Sensit
	module SubscribableApplication
		extend ::ActiveSupport::Concern
		included do
			has_many :subscriptions, :dependent => :destroy, class_name: "Sensit::Subscription", foreign_key: "application_id"
		end
	end
# end