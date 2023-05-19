class InventoryController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    @stores = Store.all
    @models = Model.all
  end

  def add
    store = Store.find_or_create_by(name: params['store'])
    model = Model.find_or_create_by(name: params['model'])

    row = Inventory.find_or_create_by(model_id: model.id, store_id: store.id)
    row.inventory = params['inventory']
    row.save
  end
end
