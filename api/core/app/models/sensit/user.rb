module Sensit
  class User < ActiveRecord::Base
  	has_many :topics, :dependent => :destroy


  	# client.indices.create({:index => current_user.name, :type => @topic.id}) unless (client.indices.exists index: @topic.id)
  end
end
