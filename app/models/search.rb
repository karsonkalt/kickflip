class Search
    attr_accessor :query

    def initialize(query)
        @query = deparametrize(query)
    end

    def name_results
        Park.all.select do |park|
            park.name.downcase.include?(@query.downcase) || park.city.downcase.include?(@query.downcase) || park.state.downcase.include?(@query.downcase)
        end
    end

    def geoloc_results
        #The /\h/ means any hexdigit character ([0-9a-fA-F])
        if @query !=~ /\h/
            nil
        else
            Park.near(@query)
        end
    end

    def all_results
        if self.geoloc_results
            (self.geoloc_results + self.name_results).uniq
        else
            self.name_results
        end
    end

    def deparametrize(str)
        str.split("-").join(" ").capitalize
    end
        
end