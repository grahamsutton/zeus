class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :customer, foreign_key: true
      t.string :name
      t.float :balance

      t.timestamps
    end
  end
end
