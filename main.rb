#!/usr/bin/env ruby
require './zeus_client'

# Get a transaction token
zeus        = ZeusClient.new
negotiation = zeus.begin
token       = negotiation['token']

# Send request to withdraw money from Wells Fargo account

# Send request to deposit money into Bank of America account
