Sensit::Api::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :except => [:new, :edit] do
			resources :subscriptions, :except => [:new, :edit]
			resources :reports, :except => [:new, :edit]
			resources :percolators, :except => [:new, :edit]
			resources :feeds, :except => [:index, :new, :edit] do
				resources :data, :only => [:show, :update]
			end
			resources :fields, :except => [:new, :edit]				
		end
	end

end
