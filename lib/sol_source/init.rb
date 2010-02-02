sol_source_path = File.expand_path(File.dirname(__FILE__))
SOL_DIR = "#{sol_source_path}/sols"

$LOAD_PATH << sol_source_path

require 'mc_lib/help'
%w( mc_lib sols ).each do |autoload_dir|
  Dir[ "#{sol_source_path}/#{autoload_dir}/**/*.rb" ].each do |f|
    load f
  end
end