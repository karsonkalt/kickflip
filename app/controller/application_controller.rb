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

        search = Search.new(params[:search])
        @query = search.query
        @parks = search.all_results
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
        erb :"parks/show"
    end

    post '/parks' do
        #Put in all param keys to initialize new park with.
        @park = Park.create(params)
        redirect "/parks/#{@park.id}"
    end

    get '/users/:id' do
        @user = User.find(params[:id])
        erb :"users/show"
    end

end