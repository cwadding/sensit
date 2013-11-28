Sensit::Api::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :nodes, :except => [:new, :edit] do
			resources :topics, :except => [:new, :edit] do
				resources :percolators, :except => [:new, :edit]
				resources :feeds, :except => [:index, :new, :edit] do
					resources :data, :except => [:new, :edit]
				end
				resources :fields, :except => [:new, :edit]				
			end
		end
	end

end
