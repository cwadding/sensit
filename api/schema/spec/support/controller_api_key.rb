# RSpec.configure do |config|
# 	config.before(:each, :type => :controller) do
# 		api_key = Sensit::ApiKey.create
# 		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(api_key.access_token)
# 	end
# end