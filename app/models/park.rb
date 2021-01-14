class Park < ActiveRecord::Base
    attr_accessor :difficulty, :geolocation, :vert_park, :stree_park, :skate_spot, :skateboard_permitted, :scooter_permitted, :bike_permitted, :open_time, :close_time

    has_many :park_edits
end