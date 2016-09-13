class Account < ApplicationRecord
  belongs_to :customer
  has_many :journal_entries, :dependent => :destroy
end
