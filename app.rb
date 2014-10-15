# ***** GEMS *****
require 'bundler'
Bundler.require


# ***** MODELS *****
require_relative 'models/party'
require_relative 'models/food'
require_relative 'models/order'


# ***** DATABASE *****
ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'restaurant'
})


# ***** ROUTES *****

# Displays links to navigate the application (including links to each current parties)
get '/' do
  @parties = Party.all.select {|party| party.is_open? }
  erb :index
end


# ----- Food CRUD -----

get '/foods' do
  @foods = Food.all
  erb :'foods/index'
end

get '/foods/new' do
  erb :'foods/new'
end

post '/foods' do
  food = Food.new(params['food'])
  if food.save
    redirect "/foods/#{ food.id }"
  else
    redirect "/foods"
  end
end

get '/foods/:id/edit' do
  @food = Food.find(params[:id])
  erb :'foods/edit'
end

patch '/foods/:id' do
  food = Food.find(params[:id])
  food.update(params['food'])
  redirect "/foods/#{ food.id }"
end

get '/foods/:id' do
  @food = Food.find(params[:id])
  erb :'foods/show'
end

delete '/foods/:id' do
  Food.delete(params[:id])
  redirect '/foods'
end



# ----- Party CRUD -----

get '/parties' do
  @parties = Party.all
  erb :'parties/index'
end

get '/parties/new' do
  erb :'parties/new'
end

post '/parties' do
  party = Party.new(params['party'])
  if party.save
    redirect "/parties/#{ party.id }"
  else
    redirect "/parties"
  end
end

get '/parties/:id/edit' do
  @party = Party.find(params[:id])
  erb :'parties/edit'
end

patch '/parties/:id' do
  party = Party.find(params[:id])
  party.update(params['party'])
  redirect "/parties/#{ party.id }"
end

get '/parties/:id' do
  @foods = Food.all
  @party = Party.find(params[:id])
  erb :'parties/show'
end

delete '/parties/:id' do
  Party.delete(params[:id])
  redirect '/parties'
end



# ----- Orders -----

post '/orders' do
  party = Party.find(params['party_id'])
  food = Food.find(params['food_id'])
  Order.create({party: party, food: food})
  redirect "/parties/#{ party.id }"
end

patch '/orders/:id' do
  order = Order.find(params[:id])
  order.update({is_free: !order.is_free})
  redirect "/parties/#{ params['party_id'] }"
end

delete '/orders/:id' do
  Order.delete(params[:id])
  redirect "/parties/#{ params['party_id'] }"
end




# ----- Receipt -----

get '/parties/:id/receipt' do
    @party = Party.find(params[:id])
  @filename = "party_#{ @party.id }_table_#{ @party.table_number.to_s}"
  @receipt = erb(:receipt_text, :layout=>nil)
  File.write("./public/receipts/#{ @filename }", @receipt)
  erb :receipt
end

patch "/parties/:id/checkout" do
  party = Party.find(params[:id])
  party.update({is_paid: true})
  redirect '/'
end
