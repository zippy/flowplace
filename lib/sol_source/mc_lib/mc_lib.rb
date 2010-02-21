require 'active_support'
module McLib
  extend self
  
  def load_dna sol  # sol should be symbol "underscore" name
    dna = {}
    [ :breath, :substrate, :transform ].each do |dim|
      dna[dim] = classes_for sol, dim
    end
    dna[:substrate] = dna[:substrate].first
    dna
  end
  
  private
  def classes_for sol, dim
    Dir["#{SOL_DIR}/#{sol}/#{dim}/*.rb"].map do |file|
      name = file.gsub!(/.*\/([^\/]*).rb$/, '\1')
      # FIXME: need better than capitalize
      Object.const_get(dim.to_s.camelize).const_get(name.to_s.camelize)
    end
  end
end