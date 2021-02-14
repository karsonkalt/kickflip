class UserTrick < ActiveRecord::Base
    belongs_to :user
    belongs_to :trick
end