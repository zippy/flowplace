module Transform
  class Rate < Breather
    def handle_breath
      rh = @substrate.rating[ b.what ] ||= {}
      rh[ b._from ] = @rating
      @substrate.average_rating[ b.what ] = rh.values.sum / rh.size 
    end
  end
end
