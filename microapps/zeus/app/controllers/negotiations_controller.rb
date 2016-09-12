class NegotiationsController < ApplicationController

  # Creates a transaction and returns it along with the token.
  def begin
    negotiation = Negotiation.create
    render :json => negotiation
  end
end
