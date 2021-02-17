class TrickController < ApplicationController 

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
    
end