Rails.application.routes.draw do

  mount Sensit::Security::Engine => "/"
end
