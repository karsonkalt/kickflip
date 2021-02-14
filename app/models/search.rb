class Search
    attr_accessor :query

    def initialize(query)
        @query = query
    end

    def name_results
        Park.all.select do |park|
            park.name.downcase.include?(@query.downcase) || park.city.downcase.include?(@query.downcase) || park.state.downcase.include?(@query.downcase)
        end
    end

    def geoloc_results
        Park.near(@query)
    end

    def all_results
        (self.geoloc_results + self.name_results).uniq
    end
        
end