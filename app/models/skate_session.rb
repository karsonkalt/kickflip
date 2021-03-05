class SkateSession < ActiveRecord::Base
    #Relationships
    belongs_to :park
    belongs_to :user

    def self.timeout
        30 #number of minutes before User can create another SkateSession
    end

    def created_at_string
        self.created_at.strftime("%B %d, %I:%M %p")
    end

end