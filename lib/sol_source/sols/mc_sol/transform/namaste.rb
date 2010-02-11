module Transform
  class Namaste < Breather
    def handle_breath
      @sol.exhale @breath._from, :namasca
    end
  end
end
