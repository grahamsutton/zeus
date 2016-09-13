# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

customers       = []
journal_entries = []

# Creates Sample Customers
10.times do
  customers << Customer.create({
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name
  })
end

# Create Random Accounts for Customers
customers.each do |customer|

  # Create a random balance
  balance = Faker::Number.between(100, 5000)

  # Create a random number of transaction to perform
  num_transactions = rand(1..5)

  # Create the account for the current customer
  account = customer.accounts.create({
    name:    Faker::GameOfThrones.house,
    balance: balance
  })

  # Create a fake account history for the current account
  num_transactions.times do

    # Create a random withdrawal/deposit amount
    transaction_amount = Faker::Number.between(5, 200)

    # Determine whether this will be a withdrawal or deposit
    action = JournalEntry.actions.to_a.sample
    action = action[0];

    # Record the sample transaction
    journal_entries << account.journal_entries.create({
      action: action,
      amount: transaction_amount
    })
  end
end