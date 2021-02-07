class Park < ActiveRecord::Base
    extend Geocoder::Model::ActiveRecord

    geocoded_by :address
    after_validation :geocode
    #check on what exactly line 6 is doing.

    has_many :skate_sessions
    has_many :users, through: :skate_sessions

    def address
        [self.street, self.city, self.state].compact.join(', ')
    end

    def create(params)
        super(params)
        self.geocode
    end
    
end