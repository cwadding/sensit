# module Sensit
	module DoorkeeperDataAuthorization
		extend ::ActiveSupport::Concern
		included do
			doorkeeper_for :index, :show, :scopes => [:read_any_data, :read_application_data]
			doorkeeper_for :create, :update, :destroy, :scopes => [:manage_any_data, :manage_application_data]
			# doorkeeper_for :all
		end
	end
# end