class StoreController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    @store = Store.find(params[:id])

    @inventory = Inventory.where(store_id: @store.id)
  end
end
