# module Sensit
	module AcceptFieldsWhenCreatingTopics
		extend ::ActiveSupport::Concern
		included do
		    # POST 1/topics
		    def create
		      field_attribute_sets = topic_params.delete(:fields)
		      @topic = current_user.topics.build(topic_params)
		      field_attribute_sets.each do |field_set|
		        @topic.fields.build(field_set)
		      end unless field_attribute_sets.blank?
		      if @topic.save
		        # create the elasticsearch index
		        client = ::Elasticsearch::Client.new        
		        respond_with(@topic,:status => :created, :template => "sensit/topics/show")
		        # render(:json => "{\"location\":#{sensit_topic_url(@topic)}}", :status => :created)
		      else
		        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
		      end
		    end

		    # PATCH/PUT 1/topics/1
		    def update
		      field_attribute_sets = topic_params.delete(:fields)
		      field_attribute_sets.each do |field_set|
		        field = @topic.fields.where(:key => field_set[:key]).first
		        field.name = field_set[:name]
		        field.save
		      end unless field_attribute_sets.blank?

		      if @topic.update(topic_params)
		        respond_with(@topic,:status => 200, :template => "sensit/topics/show")
		      else
		        render(:json => "{\"errors\":#{@topic.errors.to_json}}", :status => :unprocessable_entity)
		      end
		      
		    end
		    
		end
	end
# end