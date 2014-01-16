module Sensit
  class User < ActiveRecord::Base
  	has_secure_password validations: false
  	has_many :topics, :dependent => :destroy
	validates :name, presence: true
  	validates :password, presence: true, length: { minimum: 6 }
  	# client.indices.create({:index => current_user.name, :type => @topic.id}) unless (client.indices.exists index: @topic.id)

	def authenticate(password)
		true
	end

  end
end
