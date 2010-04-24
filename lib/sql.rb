UsingPostgres = ActiveRecord::Base.connection.class.to_s == 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
UsingMySQL = ActiveRecord::Base.connection.class.to_s == 'ActiveRecord::ConnectionAdapters::MysqlAdapter'
SQL_FULL_NAME = !UsingMySQL ? "(users.first_name||' '||users.last_name)" : "concat(users.first_name,' ',users.last_name)"
