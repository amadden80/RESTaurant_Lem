class OrdersController < ApplicationController
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
end