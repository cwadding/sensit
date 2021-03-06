Rails.application.routes.draw do

  mount Sensit::Core::Engine => "/"
  use_doorkeeper
  devise_for :users, :class_name => "Sensit::User"
  mount Sensit::Publications::Engine => "/"
end
