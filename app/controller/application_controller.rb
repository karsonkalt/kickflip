class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
    end

    get '/' do
        erb :"index"
    end
  
    get '/parks' do
        @parks = Park.all
        erb :"parks/index"
    end

    get '/parks/new' do
        erb :"parks/new"
    end

    get '/parks/:id' do
        @park = Park.find(params[:id])
        erb :"parks/park"
    end

    post '/parks' do
        #Put in all param keys to initialize new park with.
        @park = Park.create(params)
        redirect "/parks/#{@park.id}"
    end

end