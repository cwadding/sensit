Sensit::Api::Engine.routes.draw do
	scope :defaults => {:format => 'json'} do
		resources :devices, :except => [:new, :edit] do
			resources :sensors, :except => [:new, :edit] do
				resources :data_points, :except => [:new, :edit]
			end
		end
	end

end
