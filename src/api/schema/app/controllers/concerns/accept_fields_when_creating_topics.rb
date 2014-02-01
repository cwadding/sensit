# module Sensit
	module AcceptFieldsWhenCreatingTopics
		extend ::ActiveSupport::Concern
		included do
		    # POST 1/topics
		    def create
		      @topic = current_user.topics.build(topic_params.merge!(application_id: doorkeeper_token.application_id))
		      fields_params.each do |field_set|
		        @topic.fields.build(field_set)
		      end unless fields_params.blank?
		      if @topic.save
		        respond_with(@topic,:status => :created, :template => "sensit/topics/show")
		      else
		        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
		      end
		    end

		    # PATCH/PUT 1/topics/1
		    def update
		    	@topic = scoped_owner("write_any_data").topics.find(params[:id])
		      fields_params.each do |field_set|
		        field = @topic.fields.where(:key => field_set[:key]).first
		        field.name = field_set[:name]
		        field.save
		      end unless fields_params.blank?
				
		      if @topic.update(topic_params)
		        respond_with(@topic,:status => 200, :template => "sensit/topics/show")
		      else
		        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
		      end
		      
		    end
		    
			def fields_params
				if @fields_params
					@fields_params
				elsif (params.require(:topic)[:fields].present? && params[:topic][:fields].is_a?(Array))
					@fields_params ||= params[:topic][:fields].map do |field_attributes|
						ActionController::Parameters.new(field_attributes.to_hash).permit(:key, :name)
					end
				else
					[]
				end
			end

		end
	end
# end