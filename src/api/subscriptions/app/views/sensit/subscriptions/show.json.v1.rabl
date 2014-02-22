object @subscription
cache @subscription
attribute :name, :host, :protocol
node :port do |u|
	u.port
end if @subscription && @subscription.port

node :username do |u|
	u.username
end if @subscription && @subscription.username

node :password do |u|
	u.password
end if @subscription && @subscription.password