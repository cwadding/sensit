# module Sensit
	module Percolatable
		extend ::ActiveSupport::Concern
		included do
			after_create :create_rule
			after_destroy :destroy_rule

			def create_rule
				::Sensit::Rule.create(name: self.name)
			end

			def destroy_rule
				rule = ::Sensit::Rule.find_by(name: self.name)
				rule.destroy unless rule.nil?
			end			
		end
	end
# end