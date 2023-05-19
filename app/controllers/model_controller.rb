class ModelController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    @model = Model.find(params[:id])
  end
end
