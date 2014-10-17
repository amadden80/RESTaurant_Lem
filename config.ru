# ***** GEMS *****
require 'bundler'
Bundler.require


# ***** MODELS *****
require_relative 'models/party'
require_relative 'models/food'
require_relative 'models/order'

# ***** CONTROLLERS *****

require_relative 'controllers/application_controller'
require_relative 'controllers/foods_controller'
require_relative 'controllers/orders_controller'
require_relative 'controllers/parties_controller'


# ***** DATABASE *****
ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'restaurant'
})

map('/foods'){ run FoodsController }
map('/orders'){ run OrdersController }
map('/parties'){ run PartiesController }
map('/'){ run ApplicationController }


