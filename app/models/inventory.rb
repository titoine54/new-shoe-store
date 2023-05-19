class Inventory < ApplicationRecord
  belongs_to :store, class_name: 'Store'
  belongs_to :model, class_name: 'Model'
end