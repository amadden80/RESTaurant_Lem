class ApplicationController < Sinatra::Base
  # set views folder

  set :views, File.expand_path('../../views', __FILE__)

  enable :sessions



  before '/*' do
    if request.path_info != "/"
      redirect '/' if  request.cookies["RESTaurant-jar"] != "Who stole the cookie from the cookie jar... YOU"
    end
  end

  get '/' do
    @parties = Party.all.select {|party| party.is_open? }
    response.set_cookie "RESTaurant-jar", "Who stole the cookie from the cookie jar... YOU"
    erb :index
  end

end