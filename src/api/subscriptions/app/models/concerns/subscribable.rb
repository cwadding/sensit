# module Sensit
	module Subscribable
		extend ::ActiveSupport::Concern
		included do
			has_many :subscriptions, dependent: :destroy
		end
	end
# end