class Park < ActiveRecord::Base
    #Geocoder Gem
    extend Geocoder::Model::ActiveRecord

    geocoded_by :address
    after_validation :geocode #check on what exactly this line is doing

    #Relationships
    has_many :skate_sessions
    has_many :users, through: :skate_sessions

    #Validations
    validates :name, presence: true, uniqueness: true
    validates :street, presence: true
    validates :city, presence: true
    validates :state, presence: true

    #Methods for Geocoder
    def address
        [self.street, self.city, self.state].compact.join(', ')
    end

    def create(params)
        super(params)
        self.geocode
    end

    #Custom Methods
    def top_users
        counts = Hash.new(0) #Creates a new hash and sets default value to 0, {} default value is nil
        
        self.users.each do |user|
            counts[user.username] += 1
        end
        
        counts_array = counts.map do |username, count|
            [User.find_by(username: username), count]
        end

        counts_array.sort_by {|username, count| -count} #Returns array of arrays sorted by User who has most SkateSessions to least
    end

    def top_x_users(x)
        if x == 1
            self.top_users[0] #Returns single oject
        elsif x > 1
            self.top_users[0..(x-1)] #Returns array of arrays
        else
            nil
        end
    end

end