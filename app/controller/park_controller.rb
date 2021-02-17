class ParkController < ApplicationController
    
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

end