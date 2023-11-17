class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :item
      t.references :user
      t.integer :batch_count
      t.integer :coins, default: 1
      t.string :state
      t.string :serial_number

      t.timestamps
    end
  end
end
