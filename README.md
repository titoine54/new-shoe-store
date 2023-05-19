# new-shoe-store

# Setup
- start inventory generator (websocket): `.\websocketd.exe --port=8080 ruby .\inventory.rb`
- start the client service: `ruby.exe .\client.rb`
- start rails server: `rails server`

# Details
- The inventory generator publishes information about the changes in inventory to a websocket.
- The client service connects to this socket and listens for the data. When the data is received, it is parsed, then set over a HTTP call to the rails server
- The rails server receives the inventory update. The controller associated with the route saves the information in the database:
  - Creates the store if necessary
  - Creates the model if necessary 
  - Updates the associated entry in the inventory table (create or update)
- The home page of the rails app displays:
  - The shoes that are going low on stock
  - A list of all the stores with a link to the store's detailed inventory page
  - A list of all the models with a link to find the inventory of that model in all stores
