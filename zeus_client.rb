require 'rest_client'
require 'json'

class ZeusClient

  @@base_url = "http://localhost:3000"

  def begin
    response = RestClient.get("#{@@base_url}/begin", {
      :content_type => :json
    })

    JSON.parse(response)
  end
end