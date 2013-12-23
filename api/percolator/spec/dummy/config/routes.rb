Dummy::Application.routes.draw do
    mount Sensit::Percolator::Engine => "/"
end
