Sensit::Publications::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :only => [] do
			resources :publications, :except => [:new, :edit]
		end
	end	
end
