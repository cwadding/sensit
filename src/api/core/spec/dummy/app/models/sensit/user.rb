class Sensit::User < ActiveRecord::Base
	has_many :topics, :dependent => :destroy, class_name: "Sensit::Topic", foreign_key: "user_id"
	validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
