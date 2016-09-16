#!/usr/bin/env ruby
require './zeus_client'

# API Base Urls
BOFA_URL = "http://localhost:2000"
WF_URL   = "http://localhost:2100"

# Get a transaction token
zeus        = ZeusClient.new
negotiation = zeus.begin
token       = negotiation['token']

# Get a list of Wells Fargo customers
puts "Getting a list of Wells Fargo customers..."
wf_customers = zeus.get("#{WF_URL}/customers")

# Get a list of Bank of America customers
puts "Getting a list of Bank of America customers..."
bofa_customers = zeus.get("#{BOFA_URL}/customers")

puts wf_customers
puts bofa_customers


# Build the withdrawal request

# Build the deposit request

# Send request to withdraw money from Wells Fargo account


# Send request to deposit money into Bank of America account
