class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.references :store_id, null: false, foreign_key: true
      t.references :model_id, null: false, foreign_key: true
      t.integer :inventory

      t.timestamps      
    end
    add_foreign_key :inventories, :stores, column: :store_id
    add_foreign_key :inventories, :models, column: :model_id
  end
end