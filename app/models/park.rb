class Park < ActiveRecord::Base
    extend Geocoder::Model::ActiveRecord

    geocoded_by :address
    after_validation :geocode
    #check on what exactly line 5 is doing.

    has_many :skate_sessions
    has_many :users, through: :skate_sessions

    validates :name, presence: true, uniqueness: true
    validates :street, presence: true
    validates :city, presence: true
    validates :state, presence: true

    def address
        [self.street, self.city, self.state].compact.join(', ')
    end

    def create(params)
        super(params)
        self.geocode
    end

    def top_users
        counts = Hash.new(0) #creates a new hash and sets default value to 0, {} default value is nil
        self.users.each do |user|
            counts[user.username] += 1
        end
        counts.sort_by {|username, count| count}
    end
    
end