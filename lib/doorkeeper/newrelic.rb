Doorkeeper::TokensController.class_eval do
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  add_transaction_tracer :create
end