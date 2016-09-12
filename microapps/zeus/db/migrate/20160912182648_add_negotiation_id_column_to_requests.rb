class AddNegotiationIdColumnToRequests < ActiveRecord::Migration[5.0]
  def change
    add_reference :requests, :negotiation, foreign_key: true
  end
end
