require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'net/http'
require 'uri'
require 'json'

class Inventory
  def initialize
    @stores = {}
  end

  def add(message)
    if @stores.include?(message.store)
      # if stores[message.store].include?(message.model)
      @stores[message.store][message.model] = message.inventory
      # else
      #   stores[message.store][message.model] = model.inventory
    else
      @stores[message.store] = { message.model => message.inventory }
    end
    puts @stores
  end
end

class Message
  attr_accessor :store, :model, :inventory

  def initialize(store, model, inventory)
    @store = store
    @model = model
    @inventory = inventory

    check_inventory
  end

  private

  def check_inventory
    if @inventory == 0
      p "#{model} in #{store} is out of stock"
    elsif @inventory < 10
      p "Inventory low for #{model} in #{store}. Only #{inventory} left!"
    end
  end
end

inventory = Inventory.new

EM.run {
  ws = Faye::WebSocket::Client.new('ws://localhost:8080/')

  ws.on :message do |event|
    data = JSON.parse(event.data)
    
    message = Message.new(data['store'], data['model'], data['inventory'])
    
    uri = URI.parse("http://localhost:3000/inventory")
    header = {'Content-Type': 'application/json'}
    payload = { 
      :store => message.store,
      :model => message.model,
      :inventory => message.inventory,
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json

    # Send the request
    response = http.request(request)

    # inventory.add(message)
  end
}
