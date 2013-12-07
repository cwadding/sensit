Sensit::Schema::Api::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :except => [:new, :edit] do
			resources :fields, :except => [:new, :edit]
			resources :feeds, :except => [:index, :new, :edit] do
				resources :data, :only => [:show, :update]
			end
		end
	end

end
