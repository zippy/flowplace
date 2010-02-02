=begin
# Scenario: Creating my own new sol from scratch: First Breath
my_sol, my_private_key = Sol.I_am  # exhales I-amness with MC Sol

# Namaste World
mc_sol = Sol.find_by_name('MC Sol')
my_sol.exhale mc_sol, :namaste
  # record in the substrate and outstanding :namaste request

your_egg = Sol.new(McLib.load_dna('rating')) do |substrate|
  # initialize substrate
end


my_sol.exhale(your_egg, :you_are)
#your_sol, your_private_key = 

my_sol.exhale(your_sol, :who_are_you?)
#your_dna, your_init_params = 

my_sol.exhale(your_sol, :sup?)
#your_state = 

Flow.exhale( my_sol, your_sol, :sup? )


my_sol.state  # current state

my_sol.dna   # dna
my_sol.init_params  # initial params
my_sol.egg # initial state created by dna and init_params

my_sol.breaths # list of breaths?


# -------------------------------

=end




=begin 
  = DNA
    - spirations
    - state substrate
    - transformations / rules
    
  = Spirations
    - to
    - sig
    - body

=end