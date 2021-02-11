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

    def most_recent_skate_session
        if self.skate_sessions != []
            self.skate_sessions.max_by {|skate_session| skate_session[:created_at]}
        else
            nil
        end
    end

    def date_of_most_recent_skate_session
        if self.most_recent_skate_session
            most_recent_skate_session.created_at.strftime("%B %d, %I:%M %p")
        else
            nil
        end
    end

    def minutes_since_most_recent_skate_session
        if self.skate_sessions != []
            time = Time.now - self.most_recent_skate_session.created_at
            time = time/60
            time.to_i
        else
            nil
        end
    end

    def mintutes_to_wait_to_log_skate_session
        if self.skate_sessions != []
            SkateSession.timeout - self.minutes_since_most_recent_skate_session
        else
            nil
        end
    end

    def can_record_skate_session
        if self.skate_sessions != []
            self.mintutes_to_wait_to_log_skate_session > 0 ? false : true
        else
            true
        end
    end

    def number_of_skate_sessions
        self.skate_sessions.count
    end

    def self.top_users
        counts = {}
        self.all.each do |user|
            counts[user] = user.number_of_skate_sessions
        end

        counts.sort_by {|user, number_of_skate_sessions| number_of_skate_sessions}.to_a.reverse[0..9].map do |sub_array|
            sub_array[0]
        end
    end

end