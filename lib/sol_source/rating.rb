class Rating < Sol
  def intialize
  end
  
  class RatingSubstrate < Substrate
    def structure
      { :rating => :hash,
        :average_rating => :hash
      }
    end
  end
  
  class RatingBreath < Breath
    def sentence
      Sentence.new( :en => "{who} rates {what} as {rating}" )
    end
    
    def parameters
      # on influx these are instantiated into @variables
      { :who => :sol, 
        :what => :string,
        :rating => { 
          :type => :range,
          :configurable_with => :enumerable_range,
          :default => ["poor","average","good","excellent"]
        }
      }
    end
    
    def influx
      s = sol.substrate
      s.rating[@what] ||= {}
      s.rating[@what][@who.id] = @rating
      s.average_rating[@what] = (
        s.ratings[@what].values.sum / s.ratings[ @what ].size 
      )
    end
  end
  
  class AverageRule < Rule
    def condition
      
    end
    
    def transform
    end
  end
end