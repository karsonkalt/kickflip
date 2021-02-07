class Park < ActiveRecord::Base
    extend Geocoder::Model::ActiveRecord

    geocoded_by :address
    after_validation :geocode
    #check on what exactly line 6 is doing.

    def address
        [self.street, self.city, self.state].compact.join(', ')
    end

    def create(params)
        super(params)
        self.geocode
    end
    
end