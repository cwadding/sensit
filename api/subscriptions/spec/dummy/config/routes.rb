Dummy::Application.routes.draw do
  mount Sensit::Subscriptions::Engine => "/"
end
