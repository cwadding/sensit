# module Sensit
	module DoorkeeperDataAuthorization
		extend ::ActiveSupport::Concern
		included do
			doorkeeper_for :index, :show, :scopes => [:read_any_data, :read_application_data]
			doorkeeper_for :create, :update, :scopes => [:write_any_data, :write_application_data]
			doorkeeper_for :destroy,  :scopes => [:delete_any_data, :delete_application_data]
			# doorkeeper_for :all
		end
	end
# end