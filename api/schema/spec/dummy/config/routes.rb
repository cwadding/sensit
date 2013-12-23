Dummy::Application.routes.draw do
  mount Sensit::Core::Engine => "/"
  mount Sensit::Schema::Engine => "/"
end
