class Store < ApplicationRecord
    has_many :inventories, class_name: 'Inventory', foreign_key: 'store_id'
end