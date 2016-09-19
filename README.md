# Zeus

A prototypical transaction manager for microservice architectures.

---

Zeus is transaction manager written in Ruby on Rails aimed at solving the issue of achieving atomicity and data consistency in microservice architectures. I was inspired to develop this project after encountering this exact problem at my place of work, where we have been migrating our environment to a microservices architecture.

**Disclaimer**: This project is merely a demonstration of how to implement a transaction manager in a microservice environment and is not intended to be used itself.

### Zeus Components

In order to avoid any confusion, I listed out some of the components of `Zeus` - what they are and what they are for. That includes:

- **Request**: This is not the typical "request" that we think of in the HTTP paradigm. In terms of `Zeus`, the request is the parameter, the *url* and *body* that is sent to `Zeus` for `Zeus` to call on your behalf.

- **Transaction**: The transaction is a record that is created in `Zeus` and is referenced by the randomly generated token it creates. It is a reference to all requests made in a single transaction. In other words, *a transaction has many requests*. It is important to note that **a transaction is not a request** and that a transaction does not execute any urls provided to it, and therefore should not have any endpoints to accept request bodies.


### How It Works

Zeus' job as a microservice is to act as a "bridge" for a request, passing along all data from the request and calling upon that request on behalf of the main application. A request, however, must be associated to a transaction by providing the transaction token  when sending the request from the main application to Zeus.

There are three actors in this process:

- **Main App**: This is your main application. Typically this would be some kind of monolith or the app that the user is interacting with. This is also where you be sending your calls to Zeus from.

- **Zeus**: The microservice that manages requests used within a single transaction. He receives a request from the Main App, analyzes the body of that request (which contains the endpoint to the Participant) and then invokes the provided endpoint.

- **the Participant**: This is the REST API that Zeus calls on behalf of the Main App. This endpoint for the Participant would be passed in the body of the request to Zeus.

These actors are loosely associated to each other. Essentially, Zeus can make a call to any API that it has access to. 


### Obtaining a Transaction Token

In order to obtain the transaction, we can start with the following code:

    # Create Zeus client
    zeus = ZeusClient.new

    # Create a new transaction and get its record
    transaction = zeus.begin

    # Get the token from the transaction
    token = transaction['token']

We start by creating an instance of the `ZeusClient` which will be used to talk to our `Zeus` microservice. It's important to note that the `ZeusClient` is not necessary when implementing your own version. This class is simply created as a convenience wrapper for making requests to the `Zeus` microservice.

After the instance is created, we call upon Zeus to begin our transaction. In the background, the ZeusClient is sending a `GET` request to Zeus' endpoint at `/begin`. This will return the newly created record of our transaction. From there, we can grab the transaction token needed to make future requests. This token is a reference to our transaction, so in case we need to rollback all previously successful requests, we have a way to refer back to those requests.



### Making A Request

Here is a sequence diagram that explains the process of a request to Zeus:

![Making A Request](images/making-a-request-seq-diagram.png)

##### An Example:

For this example, let's make a "money transfer" between two customers, Gisela and Jorge, where each customer belongs to a different bank. Let's presume the following conditions:

- Gisela has an account at Bank A.
- Jorge has an account at Bank B.
- Gisela wants to transfer $10.00 from her account at Bank A to Jorge's account at Bank B.

Based on these preliminary conditions, we can assume the following must occur in order for this to be considered a successful transfer of funds:

- Gisela's account at Bank A must withdraw the $10.00.
- Jorge's account at Bank B must deposit the $10.00.
- Both actions must happen or neither should happen (in the case of an error).

Obviously, it may not work exactly this way in "real life" as banks typically have a much more sophisticated infrastructure where they use holding accounts for transfers. This is just a simple example to demonstrate how to achieve atomicity and data consistency, so we will skip the holding accounts for brevity.

The last bullet point is the most important. In order to achieve atomicity *for this scenario*, the third bullet point must always be true (there are some scenarios where atomicity may not imply "all-or-nothing", but I will get into that later).

We want to avoid having an instance where Gisela can withdraw the money but Jorge is not able to deposit the money, leaving the $10.00 to magically vanish. If we were to receive an error in the midst of this transaction, say, when Gisela withdrew the money but failed to deposit the money into Jorge's account, we should be able to rollback Gisela's withdrawal, leaving the impression to the user that it was never withdrawn in the first place.

Let's assume these are the following attributes for Jorge and Gisela:

    # In Bank A's database
    {id: 1, name: Gisela, accounts: [{id: 1, balance: 50.00}]}

	# In Bank B's database
    {id: 1, name: Jorge, accounts: [{id: 1, balance: 20.00}]}

**Note**: Each user in this example can have the same `id`, so long as they do not belong to the same database. The `id` attribute is a unique primary key respective of the database it belongs to.

With this data, we know that Gisela has $50.00 in her account and is a member of Bank A, and that Jorge has $20.00 in his account and is a member of Bank B.

So, let's make the request to withdraw the $10.00 from Gisela's account and deposit it into Jorge's account:

    # Define the amount to be transferred
    transfer_amount = 10.00

    # Form the withdrawal request
    withdrawal_request = {
        url:  "http://bankA.com/customers/1/accounts/1/withdraw,
        body: {
            amount: transfer_amount
        }
    }

    # Form the deposit request
    deposit_request = {
        url:  "http://bankB.com/customers/1/accounts/1/deposit,
        body: {
            amount: transfer_amount
        }
    }

    # Build the client and get a transaction token
    zeus        = ZeusClient.new
    transaction = zeus.begin
    token       = transaction['token']

    # Wrap this in a try/catch. If an exception is caught, we rollback all requests made.    
	begin

        # Make the withdrawal
        withdraw_response = zeus.request("POST", withdraw_request, token)
    
        # Make the deposit
        deposit_response = zeus.request("POST", deposit_request, token)

    rescue Exception => e

		# Rollback requests made for this transaction
        rollback_response = zeus.rollback(token)
    end
	

Notice that we use `zeus.request(request_method, request_hash, token)` method defined within our `ZeusClient`. This is merely a convenience wrapper for the raw `RestClient` call. It is highly recommended that you create a client class to manage your calls to Zeus, but it is not required.

Also notice that the withdrawal and deposit requests are wrapped in a `begin/rescue` block (this is the same as `try/catch` for most other languages). We wrap the calls in this block in order to catch an error responses from the participants. Zeus will return an exception when a call fails rather than an error message. This is so that Zeus can properly catch the exception and invoke the `rollback`.



### Rolling Back a Transaction

When Zeus detects a bad response - that is, a response that is not `200` or `201` - an exception should be thrown from within the `request` method of the client class, in this case, our `ZeusClient`. This will cause the request to jump down to the `rescue` block (the `catch` block for most other languages) and execute the `rollback` command.

Notice that we pass the transaction `token` as a parameter to our `rollback` call in order to reference all the requests that were made to that transaction. This way, we only have to call the `rollback` method once instead of having to call it for each individual request.