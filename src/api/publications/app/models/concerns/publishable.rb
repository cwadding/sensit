# module Sensit
	module Publishable
		extend ::ActiveSupport::Concern
		included do
			after_create :broadcast_create
			after_update :broadcast_update
			after_destroy :broadcast_destroy		


			def broadcast_create
				broadcast("create")
			end

			def broadcast_update
				broadcast("update")
			end

			def broadcast_destroy
				broadcast("destroy")
			end

			def after_percolate(percolators)
				publications = ::Sensit::Topic::Publication.where(topic_id: self.type).with_action(action).with_percolation(percolators)
				publications.each do |publication|
					publication.publish(self.to_hash, action)
				end
			end			

			def broadcast(action)
				# Query for all of the subscriptions which have the create type on the topic
				publications = ::Sensit::Topic::Publication.where(topic_id: self.type).with_action(action)
				publications.each do |publication|
					publication.publish(self.to_hash, action)
				end
			end
		end
	end
# end