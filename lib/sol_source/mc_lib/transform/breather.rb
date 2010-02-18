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
        handle_breath
        @breath.integrated = true
      end
    end
    
    def handle_breath
      raise "implement me in subclass!"
    end
    
    def integrate_exhale
    end
  end
end