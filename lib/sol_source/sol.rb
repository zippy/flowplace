class Breath
  
  def from
    
  end
end  

class Sol
  def initialize
    # ------  INITIAL STATE --------------- #
    @state = {}
  end
  
  
  # ----------------------------------------------------- #
  # ------------ SIGNAL / BREATH TRANSPORT -------------- #
  # ----------------------------------------------------- #
  def exhale to, *body
    breath = Breath.new( to, from=self, body )    
    breath.to.inhale breath
  end

  def inhale breath 
    Lung.new( breath ).send( breath.body.first )
    reval_rules!
  end

  # ----------------------------------------------------- #
  # ---- DNA: SIGNAL HANDLING / BREATH DEFINITIONS ------ #
  # ----------------------------------------------------- #
  #  note these are what you do when you 
  #   _receive_ a message of this type
  class Lung
    attr_reader :sol, :breath
    def initialize sol, breath
      @sol, @breath = sol, breath
    end
    
    def namaste 
      sol.exhale breath.from, :namasca
    end

    def namasca
      if @state.pending_namaste[ breath.from.id ]
        @state.pending_namaste.delete sig.from.id
      end
    end

    def you_are
    end

    def who_are_you?
      sol.exhale breath.from, :
    end

    def sup?
    end

  # ----------------------------------------------------- #
  # ------------- DNA: RULES / TRANSFORMS  -------------- #
  # ----------------------------------------------------- #
  class Ruler
    def initialize sol, state
    end
    
    def 
  end
end

