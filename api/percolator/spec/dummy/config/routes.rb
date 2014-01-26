Dummy::Application.routes.draw do
	use_doorkeeper
	devise_for :users, :class_name => "Sensit::User"
	mount Sensit::Core::Engine => "/"
    mount Sensit::Percolator::Engine => "/"
end
