class Model < ApplicationRecord
    has_many :inventories, class_name: 'Inventory', foreign_key: 'model_id'
end
