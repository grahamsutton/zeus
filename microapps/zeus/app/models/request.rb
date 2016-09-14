class Request < ApplicationRecord
  require 'rest_client'

  enum :status => {
    :pending     => "pending",
    :ok          => "ok",
    :commited    => "commited",
    :rolled_back => "rolled_back"
  }

  # Associations
  belongs_to :negotiation

  # Performs a GET request.
  #
  # @param url [String] The URL to request.
  # @return [Hash] The API response as a Hash.
  def self.get(url)
    response = RestClient.get(url, {:content_type => :json})
    JSON.parse(response)
  end

  # Performs a POST request.
  #
  # @param url [String] The URL to request.
  # @param body [Hash] The payload of the request.
  # @return [Hash] The API response as a Hash.
  def post
    response = RestClient.post(self.url, self.body, {:content_type => :json})
    JSON.parse(response)
  end
end
