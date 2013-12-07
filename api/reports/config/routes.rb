Sensit::Reports::Api::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :only => [] do
			resources :reports, :except => [:new, :edit]
		end
	end

end
