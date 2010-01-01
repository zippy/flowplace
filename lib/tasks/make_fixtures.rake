def export_table(table_name,where=1,id_field='id')
  File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
    data = ActiveRecord::Base.connection.select_all("SELECT * FROM %s where %s" % [table_name,where])
    file.write data.inject({}) { |hash, record|
      id = record[id_field]
      hash["#{table_name}_#{id}"] = record
      hash
    }.to_yaml
  end
end
  
namespace :db do
  desc 'Create YAML test fixtures from data in an existing database.  
  Defaults to development database. Set RAILS_ENV to override.'

  task :extract_fixtures => :environment do
    export_table('configurations',1)
  end
end

