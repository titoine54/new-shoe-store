class CreateSaleEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :sale_events do |t|
      t.string :store_description
      t.string :model_description

      t.timestamps
    end
  end
end
