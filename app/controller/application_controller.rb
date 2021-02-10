class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
        enable :sessions
        set :session_secret, "password"
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
        binding.pry
        @park = Park.create(params)
        redirect "/parks/#{@park.id}"
    end

    get '/users/:id' do
        @user = User.find(params[:id])
        erb :"users/show"
    end

    get '/login' do
        erb :"sessions/login"
    end

    post '/login' do
        user = User.find_by(email: params["email"])
        if user != nil
            session[:user_id] = user.id
            redirect "/users/#{user.id}"
        else
            redirect "login"
        end
    end

    get '/logout' do
        session.delete(:user_id)
        redirect "/"
    end

    error Sinatra::NotFound do
        redirect "/"
    end


    #how are the helper methods returning stuff?
    helpers do
        def current_user
            @current_user ||= User.find_by_id(session[:user_id])
        end

        def logged_in?
            !!current_user
        end
    end

end