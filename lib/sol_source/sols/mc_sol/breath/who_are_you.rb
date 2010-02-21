module Breath
  class WhoAreYou < Breath::Base
    def sentence
      Sentence.new( :en => "{_from} querys {_to}" )
    end
  
    def parameters
      {}
    end
  
    def influx
    
    end
  end
end
