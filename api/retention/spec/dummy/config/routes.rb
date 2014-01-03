Rails.application.routes.draw do

  mount Retention::Engine => "/retention"
end
