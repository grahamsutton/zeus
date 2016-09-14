class RequestsController < ApplicationController
  before_action :authenticate, :except => [:get]

  # Performs a simple GET request on behalf of the incoming request.
  def get
    response = Request.get(params[:url])
  end

  # Performs a POST request for the incoming request, stores the request as
  # status pending, and returns any response data that the request may have
  # returned.
  def post
    request = @negotiation.requests.build(params[:url], params[:body])
    response = request.post

    response_successful = response.code >= 200 && response.code <= 299

    if response_successful
      if request.save
        render :json => response
      else
        render :json => {:errors => "Could not issue your request."}
      end
    else
      render :json => {:errors => "Request failed.", :data => response}
    end
  end
end
