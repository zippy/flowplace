module Network
  extend self
  @@sols = {}
  
  def register sol
    #puts "register #{sol.name}, #{sol}"
    @@sols[sol.name] = sol
  end
  
  def lookup name
    #puts "lookup #{name} -> #{@@sols[name]}"
    @@sols[name]
  end
  
  # aka send
  def transpire to, breath
    if sol = self.lookup(to)
      sol.inhale breath
    else
      raise "No such sol '#{to}'.  sols: #{@@sols.keys.inspect}"
    end
  end
end