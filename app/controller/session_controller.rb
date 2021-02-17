class SessionController < ApplicationController 

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

end