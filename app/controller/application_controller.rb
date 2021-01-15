class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
    end
  
    get '/parks' do
        @parks = Park.all
        erb :"parks/index"
    end

    post '/parks' do
        #Put in all param keys to initialize new park with.
        @park = Park.create(name: params["name"],)
        @park.id
    end

end