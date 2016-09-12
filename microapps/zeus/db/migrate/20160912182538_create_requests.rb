class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :url
      t.string :method
      t.string :status
      t.text :body

      t.timestamps
    end
  end
end
