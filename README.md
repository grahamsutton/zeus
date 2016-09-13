# Zeus

A transaction manager for microservices.

---

Zeus is transaction manager written in Ruby aimed at solving the issue of achieving atomicity in microservice architectures. I was inspired to develop this project after encountering this exact problem at my place of work, where we have been migrating our environment to a microservice architecture.

**Disclaimer**: This project is merely a demonstration of how to implement a transaction manager in a microservice environment and is not intended to be used itself.


### How It Works

We start by calling the creating an instance of the `ZeusClient` which will be used to talk to our `Zeus` microservice.

After the instance is created, we call upon Zeus to begin our transaction by sending a `GET` request to `/begin`. This will return the record of our transaction. From there, we can grab the transaction token needed to make requests:

    # Create Zeus client
    zeus        = ZeusClient.new

    # Create a new transaction and get its record
    transaction = zeus.begin

    # Get the token from the transaction
    token       = transaction['token']
