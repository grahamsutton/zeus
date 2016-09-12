class Request < ApplicationRecord

  enum :status => {
    :pending     => "pending",
    :ok          => "ok",
    :commited    => "commited",
    :rolled_back => "rolled_back"
  }

  # Associations
  belongs_to :negotiation
end
