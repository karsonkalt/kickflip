class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
    end

    get '/' do
        erb :"index"
    end

    post '/parks/search' do

        #This isn't "RESTFUL" it should be ?q= <something like this>

        # Every query should be a new search object, not this. This should me in models.
        @search = params[:search].downcase
        @search_geoloc = Park.near(@search)
        @search_attr = Park.all.select do |park|
            #searches for exact matches in the Park.all array
            park.name.downcase.include?(@search) || park.city.downcase.include?(@search) || park.state.downcase.include?(@search)
            
        end
        @parks = (@search_geoloc + @search_attr).uniq
        erb :"parks/search"
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