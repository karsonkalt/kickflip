class ApplicationController < Sinatra::Base

    configure do
        set :views, "app/views"
        set :public_dir, "public"
        enable :sessions
        set :session_secret, "Zt+gPPN/yrRg+sQyFmvRxOnIXNr8wamnmLkOGknhq9LYeSmPGdoSRVgq1rJ+gnLFTrF2WUe3vSj3orQ7"
        set :method_override, true
        register Sinatra::Flash
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
        search = params[:search].parameterize
        redirect "/parks?q=#{search}"
    end
  
    get '/parks' do
        #The ?q= method is already built into sinatra routes
        if params[:q]
            search = Search.new(params[:q])
            @query = search.query
            @parks = search.all_results
            erb :"parks/search"       
        else
            @parks = Park.all
            erb :"parks/index"
        end
    end

    get '/parks/new' do
        redirect_if_not_logged_in
        erb :"parks/new"
    end

    get '/parks/:id' do
        @park = Park.find_by_id(params[:id])
        if @park
            erb :"parks/show"
        else
            flash[:error] = "That park does not exist."
            redirect "/"
        end
    end

    post '/parks' do
        #Put in all param keys to initialize new park with.
        @park = Park.create(params)
        flash[:success] = "#{@park.name} successfully added."
        redirect "/parks/#{@park.id}"
    end

    get '/parks/:id/edit' do
        redirect_if_not_admin
        @park = Park.find_by_id(params[:id])
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
        flash[:success] = "#{park.name} successfully updated."
        redirect "/parks/#{park.id}"
    end

    get '/parks/:id/delete' do
        redirect_if_not_admin
        @park = Park.find(params[:id])
        erb :"parks/delete"
    end

    delete '/parks/:id' do
        redirect_if_not_admin
        park = Park.find(params[:id])
        skate_sessions = SkateSession.all.select do |skate_session|
            skate_session.park_id == park.id
        end
        flash[:info] = "Successfully deleted #{park.name} and #{skate_sessions.count} checkins."
        park.destroy
        skate_sessions.each do |skate_session|
            skate_session.destroy
        end
        redirect "/"
    end

    get '/users' do
        @users = User.top_users
        erb :"users/index"
    end

    get '/users/:id' do
        @user = User.find_by_id(params[:id])
        if @user
            erb :"users/show"
        else
            flash[:error] = "That user does not exist."
            redirect "/"
        end
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
        user.password = params[:password]
        user.email = params[:email]
        user.save
        flash[:success] = "User info successfully updated."
        redirect "/users/#{user.id}"
    end

    get '/users/:id/delete' do
        redirect_if_user_not_authorized(User.find(params[:id]))
        @user = User.find(params[:id])
        erb :"users/delete"
    end

    delete '/users/:id' do
        redirect_if_user_not_authorized(User.find(params[:id]))
        user = User.find(params[:id])
        skate_sessions = SkateSession.all.select do |skate_session|
            skate_session.user_id == user.id
        end
        user_tricks = UserTrick.all.select do |user_trick|
            user_trick.user_id == user.id
        end
        flash[:info] = "Successfully deleted your account, #{skate_sessions.count} checkins, and #{user_tricks.count} logged tricks."
        user.destroy
        skate_sessions.each do |skate_session|
            skate_session.destroy
        end
        user_tricks.each do |user_trick|
            user_trick.destroy
        end
        session.delete(:user_id)
        redirect "/"
    end

    get '/users/:id/skate-sessions' do
        redirect_if_user_not_authorized(User.find(params[:id]))
        @user = User.find(params[:id])
        erb :"users/skate_sessions"
    end

    post '/skate-sessions' do
        park_id = params["park_id"].to_i
        SkateSession.create(user_id: current_user.id, park_id: park_id)
        flash[:success] = "Checkin successfully added."
        redirect "/parks/#{park_id}"
    end

    delete '/skate-sessions/:id' do
        skate_session = SkateSession.find(params[:id])
        skate_session.destroy
        flash[:info] = "Checkin deleted."
        redirect "/users/#{current_user.id}/skate-sessions"
    end

    post '/tricks' do
        trick_id = params["trick_id"].to_i
        UserTrick.create(user_id: current_user.id, trick_id: trick_id)
        flash[:success] = "#{Trick.find(params["trick_id"]).name} added to your tricks."
        redirect "/users/#{current_user.id}"
    end

    delete '/tricks/:id' do
        user_trick = UserTrick.find_by(trick_id: params["trick_id"], user_id: current_user.id)
        flash[:info] = "#{Trick.find(params["trick_id"]).name} removed from your tricks."
        user_trick.destroy
        redirect "/users/#{current_user.id}"
    end

    get '/login' do
        redirect_if_logged_in
        erb :"sessions/login"
    end

    post '/login' do
        user = User.find_by(email: params["email"])&.authenticate(params['password'])
        if user != nil
            session[:user_id] = user.id
            flash[:success] = "Welcome back to Kickflip, #{user.username}!"
            redirect "/users/#{user.id}"
        else
            flash[:error] = "Invalid login."
            redirect "login"
        end
    end

    get '/logout' do
        session.delete(:user_id)
        flash[:info] = "Successfully logged out."
        redirect "/"
    end

    get '/signup' do
        redirect_if_logged_in
        erb :"users/new"
    end

    post '/users' do
        if User.find_by_username(params[:username])
            flash[:error] = "Username already taken."
            redirect "/signup"
        elsif User.find_by_email(params[:email])
            flash[:error] = "Email already in use."
            redirect "/signup"
        else
            user = User.new
            user.username = params[:username]
            user.password = params[:password]
            user.email = params[:email]
            user.save
            session[:user_id] = user.id
            flash[:success] = "Welcome to Kickflip, #{user.username}!"
            redirect "/"
        end
    end

    error Sinatra::NotFound do
        flash[:error] = "That page does not exist."
        redirect "/"
    end

    helpers do
        def current_user
            @current_user ||= User.find_by_id(session[:user_id])
        end

        def logged_in?
            !!current_user
        end

        def redirect_if_not_logged_in
            if logged_in? == false
                flash[:error] = "You must be logged in to access that page."
                redirect "/"
            end
        end

        def redirect_if_logged_in
            if logged_in? == true
                flash[:error] = "You are already logged in."
                redirect "/"
            end
        end

        def redirect_if_user_not_authorized(user)
            if user.id != current_user.id
                flash[:error] = "You can not edit someone else's data."
                redirect "/"
            end
        end

        def redirect_if_not_admin
            if logged_in? == false || current_user.admin_status == false
                flash[:error] = "You must be an admin to access that page."
                redirect "/"
            end
        end
    end

end