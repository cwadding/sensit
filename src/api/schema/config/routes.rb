Sensit::Schema::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :only => [] do
			resources :fields, :except => [:new, :edit]
		end
	end
end
