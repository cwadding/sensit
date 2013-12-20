Dummy::Application.routes.draw do
  mount Sensit::Subscriptions::Api::Engine => "/"
end
