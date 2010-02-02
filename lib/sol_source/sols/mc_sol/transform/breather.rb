module Transform
  class Breather < Base
    def morph
      if (@breath = @substrate.exhale_log[-1] and
          @breath.class.name.split(':').last == self.class.name.split(':').last)
        integrate_exhale
        @breath.integrated = true
      end
      
      if (@breath = @substrate.inhale_log[-1] and
          @breath.class.name.split(':').last == self.class.name.split(':').last)
        integrate_inhale
        @breath.integrated = true
      end
    end
  end
end