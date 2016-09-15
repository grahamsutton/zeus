# Zeus

A prototypical transaction manager for microservices.

---

Zeus is transaction manager written in Ruby on Rails aimed at solving the issue of achieving atomicity and data consistency in microservice architectures. I was inspired to develop this project after encountering this exact problem at my place of work, where we have been migrating our environment to a microservice architecture.

**Disclaimer**: This project is merely a demonstration of how to implement a transaction manager in a microservice environment and is not intended to be used itself.


### How It Works

Zeus' job as a microservice is to act as a "bridge" for a request, passing along all data from the request and calling upon that request on behalf of the main application. A request, however, must be associated to a transaction by providing the transaction token  when sending the request from the main application to Zeus.

In order to obtain the transaction, we can start with the following code:

    # Create Zeus client
    zeus = ZeusClient.new

    # Create a new transaction and get its record
    transaction = zeus.begin

    # Get the token from the transaction
    token = transaction['token']

We start by creating an instance of the `ZeusClient` which will be used to talk to our `Zeus` microservice.

After the instance is created, we call upon Zeus to begin our transaction. In the background, the ZeusClient is sending a `GET` request to Zeus' endpoint at `/begin`. This will return the newly created record of our transaction. From there, we can grab the transaction token needed to make future requests. This token is a reference to our transaction, so in case we need to rollback all previously successful requests, we have a way to refer back to those requests.



### Making A Request

Here is a sequence diagram that explains the process of a request to Zeus:

![Making A Request](images/making-a-request-seq-diagram.png)