module Transform
  class Namasca < Breather
    def handle_breath
      @substrate.pending_namasca[ breath.from.id ] = false
    end
  end
end
