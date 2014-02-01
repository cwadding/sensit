Sensit::UnitConversion::Engine.routes.draw do
	scope :path => "api", :defaults => {:format => 'json'} do
		resources :topics, :only => [] do

		end
	end

end