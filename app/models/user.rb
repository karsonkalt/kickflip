class User < ActiveRecord::Base
    has_many :skate_sessions
    has_many :parks, through: :skate_sessions

end