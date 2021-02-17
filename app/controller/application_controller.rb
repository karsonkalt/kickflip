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