Sensit::Core::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :sessions, :only => [:create, :destroy]
		resources :topics, :except => [:new, :edit] do
			resources :feeds, :except => [:index, :new, :edit] do
				resources :data, :only => [:show, :update]
			end
		end
	end
end
