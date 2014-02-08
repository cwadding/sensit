Sensit::Subscriptions::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :subscriptions, :except => [:new, :edit]
	end

end
