module Breath
  class Namaste < Base
    def sentence
      Sentence.new( :en => "{_from} greets {_to}" )
    end
  
    def parameters
      {}
    end
  end
end
