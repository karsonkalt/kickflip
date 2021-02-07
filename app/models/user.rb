class User < ActiveRecord::Base
    #Relationships
    has_many :skate_sessions
    has_many :parks, through: :skate_sessions

    #Validations
    validates :username, presence: true, uniqueness: true
    # validates :password, presence: true

    # has_secure_password

    #Custom Methods
    def top_parks
        counts = Hash.new(0) #Creates a new hash and sets default value to 0, {} default value is nil
        
        self.parks.each do |park|
            counts[park.name] += 1
        end
        
        counts_array = counts.map do |name, count|
            [Park.find_by(name: name), count]
        end

        counts_array.sort_by {|name, count| -count} #Returns array of arrays sorted by Park with the most SkateSessions to least
    end

    def top_x_parks(x)
        if x == 1
            self.top_parks[0][0] #Returns single oject
        elsif x > 1
            self.top_parks[0..(x-1)] #Returns array of arrays
        else
            nil
        end
    end

end