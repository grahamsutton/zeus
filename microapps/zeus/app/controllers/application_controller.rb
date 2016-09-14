class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  @negotiation

  # Authenticates the incoming request with a transaction that already exists
  # in the database.
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @negotiation = Negotiation.find_by(:token => token)
    end
  end
end
