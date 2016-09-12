class CreateNegotiations < ActiveRecord::Migration[5.0]
  def change
    create_table :negotiations do |t|
      t.string :token
      t.string :status

      t.timestamps
    end
  end
end
