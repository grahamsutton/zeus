class CreateJournalEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :journal_entries do |t|
      t.belongs_to :account, foreign_key: true
      t.string :action
      t.float :amount
      t.string :new_balance

      t.timestamps
    end
  end
end
