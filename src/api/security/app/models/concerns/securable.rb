# module Sensit
	module Reportable
		extend ::ActiveSupport::Concern
		included do
			belongs_to :api_key
			validates :name, presence: true, uniqueness:  {scope: :api_key_id}
		endsensit
	end
# end