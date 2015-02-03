# required monkey patching in order to add MULTI_STATEMENTS flag
if defined?(ActiveRecord)
  module ActiveRecord
    class Base
      # Establishes a connection to the database that's used by all Active Record objects.
      def self.mysql2_connection(config)
        config[:username] = 'root' if config[:username].nil?
   
        if Mysql2::Client.const_defined? :FOUND_ROWS
          config[:flags] = Mysql2::Client::FOUND_ROWS | Mysql2::Client::MULTI_STATEMENTS
        end
        
        client = Mysql2::Client.new(config.symbolize_keys)
        options = [config[:host], config[:username], config[:password], config[:database], config[:port], config[:socket], 0]
        ConnectionAdapters::Mysql2Adapter.new(client, logger, options, config)
      end
    end
  end
end

class MysqlActiveRecordBenchmark < CacheBenchmark
  attr_reader :client
  def initialize(status, counter, logger)
    super

    @config = { adapter: 'mysql2', database: 'benchmark', host: '127.0.0.1', password: 'root', pool: 2}
    @client = ActiveRecord::Base.establish_connection(@config)
  end

  def reset
    ActiveRecord::Base.connection_pool.with_connection do |c| 
      c.execute('TRUNCATE TABLE cache')
    end
  end

  def execute
    sql = 'LOCK TABLES `cache` WRITE; INSERT INTO `cache` VALUES (\'counter\', 1) ON DUPLICATE KEY UPDATE `value` = `value` + 1; SELECT `value` FROM cache WHERE `key` = \'counter\'; UNLOCK TABLES;'
    ActiveRecord::Base.connection_pool.with_connection do |conn|
      raw = conn.raw_connection

      result = raw.query(sql)
      values = []
      while raw.next_result
        result = raw.store_result.to_a
        values << result.first unless result.empty?
      end
      
      values[0][0] unless values.empty? || values[0].empty?
    end
  end
end 
