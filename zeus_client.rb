require 'rest_client'
require 'json'

class ZeusClient

  @@base_url = "http://localhost:3000"

  # Calls the Zeus microservice at the endpoint "/begin", which returns
  # a transaction record that contains the transaction token needed to make
  # future requests.
  #
  # @return [Hash] Returns a JSON response parsed to a Hash.
  def begin
    response = RestClient.get("#{@@base_url}/begin", {
      :content_type => :json
    })

    # Parse and return a hash
    JSON.parse(response)
  end

  # Convenience method to make a GET request.
  #
  # @param url [String] The URL to call.
  def get(url)
    response = RestClient.get(url, {
      :content_type => :json,
      :accept       => :json
    })

    # Parse and return a hash
    JSON.parse(response)
  end

  # Sends the request to the Zeus microservice, where Zeus will record the 
  # request as a member of the provided transaction. The request is recorded
  # if Zeus receives a response code of 200 or 201.
  #
  # @param transaction_token [String] The reference to the transaction in progress.
  # @param request [Hash] The hash containting the body, request_method, and url
  #     properties.
  def request(transaction_token, request)
    response = RestClient.post("#{@@base_url}/request", request, {
      :content_type => :json,
      :accept       => :json
    })

    # Parse and return a hash
    JSON.parse(response)
  end
end