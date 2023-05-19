class StoreController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    @store = Store.find(params[:id])
  end
end

