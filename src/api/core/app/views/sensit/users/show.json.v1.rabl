object @user
attribute :name, :email

child @topics => "topics" do
	attribute :name, :description
	node :id do |u|
		u.slug
	end
end