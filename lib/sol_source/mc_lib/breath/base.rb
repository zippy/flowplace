module Breath
  class Base
    attr_accessor :to,:from,:body,:integrated
    def initialize to, from, body
      @to,@from,@body = to,from,body
    end

  end
end