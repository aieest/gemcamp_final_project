class CreateItemCategoryShips < ActiveRecord::Migration[7.0]
  def change
    create_table :item_category_ships do |t|
      t.references :item
      t.references :category
      t.timestamps
    end
  end
end
