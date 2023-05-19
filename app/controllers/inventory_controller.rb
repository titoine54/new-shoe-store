class InventoryController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    @stores = Store.all
    @models = Model.all
    @alerts = Inventory.where("inventory < ? ", 10)
    @high_inventory = get_high_inventory
    @low_inventory = get_low_inventory
    @top_sellers = get_top_sellers
  end

  def add
    record_sale_event(params)
    store = Store.find_or_create_by(name: params['store'])
    model = Model.find_or_create_by(name: params['model'])

    row = Inventory.find_or_create_by(model_id: model.id, store_id: store.id)
    row.inventory = params['inventory']
    row.save
  end

  private

  def get_high_inventory
    high_inventory_models = Inventory.group(:model_id).average(:inventory)

    top_high_inventory_models = high_inventory_models.sort_by { |model| -model[1] }.first(3)
    top_high_inventory_models.map { |model, inventory| [Model.find_by_id(model).name, inventory.to_i] }
  end

  def get_low_inventory
    low_inventory_models = Inventory.group(:model_id).average(:inventory)

    top_low_inventory_models = low_inventory_models.sort_by { |model| model[1] }.first(3)
    top_low_inventory_models.map { |model, inventory| [Model.find_by_id(model).name, inventory.to_i] }.reverse
  end

  def get_top_sellers
    now = Time.zone.now.beginning_of_day
    SaleEvent.where("created_at >= ?", now).group(:model_description).order(Arel.sql('COUNT(*) DESC')).limit(5).count(:id)
  end

  def record_sale_event(params)
    SaleEvent.create(model_description: params['model'], store_description: params['store'])
  end
end
