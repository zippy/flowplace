require ENV['DEPREC_PATH'] ? ENV['DEPREC_PATH'] : 'deprec'

subdomain = ENV['CAP_DOMAIN']


if subdomain && subdomain != ''
  set :domain, subdomain+'.flowplace.org'
else
  set :domain, "dev.flowplace.org"
end

case domain
when 'demo.flowplace.org'
  set :user, "ehb"
  set :application, 'flowplace_demo'
  set :ssh_port,22
when 'seed.flowplace.org'
  set :user, "ehb"
  set :application, 'flowplace_seed'
  set :ssh_port,22
when 'dev.flowplace.org'
  set :user, "eric"
  set :application, 'flowplace'
  set :ssh_port,22
end

puts "*** Domain: \033[1;41m #{domain} \033[0m"

ssh_options[:port] = ssh_port

set :repository,  "git://github.com/zippy/flowplace.git"

set :gems_for_project, %w(gravtastic) # list of gems to be installed

set :deploy_to, "/opt/apps/#{application}"
set :ruby_vm_type,      :ree        # :ree, :mri

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, true  
set :database_yml_in_scm, false
set :passenger_use_mod_rewrite_for_disable, false
   
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :mysql      # :mysql, :postgresql, :sqlite

# set :packages_for_project, %w(libmagick9-dev imagemagick libfreeimage3) # list of packages to be installed
# set :gems_for_project, %w(rmagick mini_magick image_science) # list of gems to be installed

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db,  domain, :primary => true

after 'deploy:symlink', :roles => :app do
  run "ln -nfs #{shared_path}/config/flowplace_config.rb #{release_path}/config/flowplace_config.rb" 
end

task :fish do
  run 'ls'
end
task :flowplace_install do
#  top.upload_certs
#  top.deprec.rails.install_stack
  
  sudo 'gem install rails --version 2.2.2 --no-ri --no-rdoc'
#  sudo 'gem sources -a http://gems.github.com'
#  sudo 'gem install mislav-will_paginate --no-ri --no-rdoc'
#  top.deprec.db.install

#  top.deploy.setup
#  top.deploy.default

#  top.deploy.migrate
end
namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.app.restart
  end
  task :symlink_flowplace_config do
    run "ln -nfs #{shared_path}/config/flowplace_config.rb #{current_path}/config/flowplace_config.rb" 
  end
end