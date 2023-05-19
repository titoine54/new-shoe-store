require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'net/http'
require 'uri'
require 'json'

class Message
  attr_accessor :store, :model, :inventory

  def initialize(store, model, inventory)
    @store = store
    @model = model
    @inventory = inventory
  end
end

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

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json

    response = http.request(request)
  end
}
