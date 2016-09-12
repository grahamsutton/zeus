class Negotiation < ApplicationRecord
  
  enum :status => {
    :pending     => "pending",
    :commited    => "commited",
    :rolled_back => "rolled_back"
  }

  # Callbacks
  before_save :generate_token, :set_default_status

  # Associations
  has_many :requests, :dependent => :destroy

  private

    # Generates a transaction token to refer back to this transaction.
    def generate_token
      self.token = loop do
        random_token = SecureRandom.hex
        break random_token unless Negotiation.exists?(token: random_token)
      end
    end

    # Sets the default status as "pending" for the newly created transaction.
    def set_default_status
      self.status = :pending
    end
end
