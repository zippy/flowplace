class Flow
  class << self
    def release breath
      # assume Breath#to returns sol reference
      sol = Sol.find(breath.to)
      sol.inhale breath      
    end
  end
end