class SkateSessionController < ApplicationController 

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
    
end