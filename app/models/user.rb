class User < ActiveRecord::Base
    has_many :skate_sessions
    has_many :parks, through: :skate_sessions

    # validates :username, presence: true, uniqueness: true
    # validates :password, presence: true

    # has_secure_password

end