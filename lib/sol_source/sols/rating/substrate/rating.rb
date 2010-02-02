module Substrate
  class Rating < Base
    def structure 
      # NOTE: name collisions may result
      super.merge({ 
        :rating => {},
        :average_rating => {}
      })
    end
  end
end