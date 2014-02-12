# module Sensit
	module Publishable
		extend ::ActiveSupport::Concern
		included do
			after_create :broadcast_create, :broadcast_percolate
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

			def broadcast_percolate
				result = self.percolate
				publish(::Sensit::Topic::Publication.where(topic_id: self.type).with_percolations(result["matches"])) if (result && result["ok"] && result["matches"])
			end			

			def broadcast(action)
				# Query for all of the subscriptions which have the create type on the topic
				publish(::Sensit::Topic::Publication.where(topic_id: self.type).with_action(action))
			end

			def publish(publications)
				publications.each do |publication|
					publication.publish(self.to_hash, action)
				end unless publications.blank? 
			end
		end
	end
# end