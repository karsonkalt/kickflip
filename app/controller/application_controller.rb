class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
        enable :sessions
        set :session_secret, "password"
        set :method_override, true
    end

    get '/' do
        if logged_in?
            @parks = Park.all
            erb :"parks/index"
            # redirect "/users/#{current_user.id}" 
        else
            @parks = Park.all
            erb :"parks/index"
        end
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
        redirect_if_not_logged_in
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

    get '/parks/:id/edit' do
        redirect_if_not_admin
        @park = Park.find(params[:id])
        erb :"parks/edit"
    end

    patch '/parks/:id' do
        park = Park.find(params[:id])
        park.name = params[:name]
        park.city = params[:city]
        park.state = params[:state]
        park.skateboard_permitted = params[:skateboard_permitted]
        park.scooter_permitted = params[:scooter_permitted]
        park.bike_permitted = params[:bike_permitted]
        park.geocode
        park.save
        redirect "/parks/#{park.id}"
    end

    get '/users' do
        @users = User.top_users
        erb :"users/index"
    end

    get '/users/:id' do
        @user = User.find(params[:id])
        erb :"users/show"
    end

    get '/users/:id/edit' do
        @user = User.find(params[:id])
        redirect_if_user_not_authorized(@user)
        erb :"users/edit"
    end
    
    patch '/users/:id' do
        user = User.find(params[:id])
        user.username = params[:username]
        #Build user.password method
        user.email = params[:email]
        user.save
        redirect "/users/#{user.id}"
    end

    get '/users/:id/skate-sessions' do
        redirect_if_user_not_authorized(User.find(params[:id]))
        @user = User.find(params[:id])
        erb :"users/skate_sessions"
    end

    post '/skate-sessions' do
        park_id = params["park_id"].to_i
        SkateSession.create(user_id: current_user.id, park_id: park_id)
        redirect "/parks/#{park_id}"
    end

    delete '/skate-sessions/:id' do
        skate_session = SkateSession.find(params[:id])
        skate_session.destroy
        redirect "/users/#{params[:user_id]}/skate-sessions"
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

    get '/signup' do
        redirect_if_logged_in
        erb :"users/new"
    end

    post '/users' do
        if User.find_by_username(params[:username]) || User.find_by_email(params[:email])
            #flash an error
            binding.pry
            redirect "/signup"
        else
            user = User.new
            #set the password
            user.username = params[:username]
            user.email = params[:email]
            user.save
            session[:user_id] = user.id
            redirect "/"
        end
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

        def redirect_if_not_logged_in
            if logged_in? == false
                redirect "/"
            end
        end

        def redirect_if_logged_in
            if logged_in? == true
                redirect "/"
            end
        end

        def redirect_if_user_not_authorized(user)
            if user.id != current_user.id
                redirect "/"
            end
        end

        def redirect_if_not_admin
            if logged_in? == false || current_user.admin_status == false
                redirect "/"
            end
        end
    end

end