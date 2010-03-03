require 'foreigner/connection_adapters/abstract/schema_statements'
require 'foreigner/connection_adapters/abstract/schema_definitions'
require 'foreigner/connection_adapters/sql_2003'
require 'foreigner/schema_dumper'

module ActiveRecord
  module ConnectionAdapters
    include Foreigner::ConnectionAdapters::SchemaStatements
    include Foreigner::ConnectionAdapters::SchemaDefinitions
  end
  
  SchemaDumper.class_eval do
    include Foreigner::SchemaDumper
  end
  
  Base.class_eval do
    case connection_pool.spec.config[:adapter].downcase
    when /^(mysql|postgresql)$/
      require "foreigner/connection_adapters/#{connection_pool.spec.config[:adapter].downcase}_adapter"
    when "jdbcmysql"
      require "foreigner/connection_adapters/mysql_adapter"
    end
  end
end
