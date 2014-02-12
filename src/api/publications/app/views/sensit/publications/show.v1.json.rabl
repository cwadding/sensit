object @publication
attribute :name, :host, :protocol
node :port do |u|
	u.port
end if @publication && @publication.port

node :username do |u|
	u.username
end if @publication && @publication.username

node :password do |u|
	u.password
end if @publication && @publication.password