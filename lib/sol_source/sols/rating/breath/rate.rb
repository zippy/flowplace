module Breath
  class Rate < Base
    def sentence
      Sentence.new( :en => "{_from} rates {what} as {rating}" )
    end
    
    def parameters
      # on influx these are instantiated into @variables
      { 
        :what => :string,
        :rating => { 
          :type => :range,
          :configurable_with => :enumerable_range,
          :default => ["poor","average","good","excellent"]
        }
      }
    end
  end
end
