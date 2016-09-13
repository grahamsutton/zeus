class JournalEntry < ApplicationRecord
  belongs_to :account

  before_save :alter_account_balance

  enum :action => {
    :withdraw => "withdraw",
    :deposit  => "deposit"
  }

  private

    # Updates the customer's account balance just before saving it to the 
    # database.
    def alter_account_balance

      if self.withdraw?
        self.account.balance -= self.amount
      elsif self.deposit?
        self.account.balance += self.amount
      end

      # Calculcate the new balance at the time of the transaction.
      self.new_balance = self.account.balance

      # Save the account balance
      self.account.save!
    end
end
