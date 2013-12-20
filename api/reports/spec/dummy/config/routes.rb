Dummy::Application.routes.draw do
  mount Sensit::Reports::Api::Engine => "/"
end
