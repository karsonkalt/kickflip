class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
    end
  
    get '/parks' do
        @parks = Park.all
        erb :"parks/index"
    end
#figure out how to pass in ID to generate individual pages
    get '/parks/:id' do
        @park = Park.find(id)
        erb :"parks/park"
    end

    post '/parks' do
        #Put in all param keys to initialize new park with.
        @park = Park.create(name: params["name"],)
        @park.id
    end

end