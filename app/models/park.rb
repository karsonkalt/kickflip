class Park < ActiveRecord::Base
    extend Geocoder::Model::ActiveRecord

    has_many :park_edits
    geocoded_by :address
    after_validation :geocode

    def address
        [self.street, self.city, self.state].compact.join(', ')
    end

    
end