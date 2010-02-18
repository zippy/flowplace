module Transform
  class Namasca < Breather
    def handle_breath
      @substrate.pending_namasca[ breath.from.name ] = false
    end
  end
end
