class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item
      t.references :ticket
      t.references :user
      t.references :address
      t.integer :item_batch_count
      t.string :state
      t.decimal :price, precision: 10, scale: 2, default: 0
      t.datetime :paid_at
      t.references :admin, foreign_key: { to_table: :users }
      t.string :picture
      t.text :comment

      t.timestamps
    end
  end
end
