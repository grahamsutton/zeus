class Customer < ApplicationRecord
  has_many :accounts, :dependent => :destroy

  validates :first_name, :presence => true
  validates :last_name,  :presence => true
end
