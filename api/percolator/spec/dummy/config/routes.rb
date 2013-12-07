Dummy::Application.routes.draw do
    mount Sensit::Percolator::Api::Engine => "/"
end
