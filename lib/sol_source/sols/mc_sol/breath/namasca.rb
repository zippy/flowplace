module Breath
  class Namasca < Base
    def sentence
      Sentence.new( :en => "{_from} acknowledges greeting from {_to}" )
    end
  
    def parameters
      {}
    end
  end
end