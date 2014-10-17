class PartiesController < ApplicationController
  get '/' do
    @parties = Party.all
    erb :'parties/index'
  end

  get '/new' do
    erb :'parties/new'
  end

  post '/' do
    party = Party.new(params['party'])
    if party.save
      redirect "/parties/#{ party.id }"
    else
      redirect "/parties"
    end
  end

  get '/:id/edit' do
    @party = Party.find(params[:id])
    erb :'parties/edit'
  end

  patch '/:id' do

    party = Party.find(params[:id])

    if message = params['personal-message']
      session['message_'+ party.id.to_s ] = message
    end

    party.update(params['party'])
    redirect "/parties/#{ party.id }"
  end

  get '/:id' do
    @foods = Food.all
    @party = Party.find(params[:id])
    erb :'parties/show'
  end

  delete '/:id' do
    Party.delete(params[:id])
    redirect '/parties'
  end

  get '/:id/receipt' do
    @party = Party.find(params[:id])
    @filename = "party_#{ @party.id }_table_#{ @party.table_number.to_s}"
    @personal_message = session['message_'+ @party.id.to_s ] || "Thank You."
    @receipt = erb(:receipt_text, :layout=>nil)
    File.write("./public/receipts/#{ @filename }", @receipt)
    erb :receipt
  end

  patch "/:id/checkout" do
    party = Party.find(params[:id])
    session['message_'+ @party.id.to_s ] = nil
    party.update({is_paid: true})
    redirect '/'
  end
end