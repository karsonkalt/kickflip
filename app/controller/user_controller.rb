class UserController < ApplicationController
    
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
    
end