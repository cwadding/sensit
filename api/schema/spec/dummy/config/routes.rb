Dummy::Application.routes.draw do
  mount Sensit::Schema::Api::Engine => "/"
end
