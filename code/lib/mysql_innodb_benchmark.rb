class MysqlInnodbBenchmark < CacheBenchmark
  attr_reader :client
  def initialize(status, counter, logger)
    super
    @client = Mysql2::Client.new(host: "127.0.0.1", username: "root", password: "root", port: 3306, flags: Mysql2::Client::MULTI_STATEMENTS)
  end

  def reset
    client.query("TRUNCATE TABLE benchmark.`cache_innodb`;")
  end

  def execute
    sql = 'LOCK TABLES benchmark.`cache_innodb` WRITE; INSERT INTO benchmark.`cache_innodb` VALUES (\'counter\', 1) ON DUPLICATE KEY UPDATE `value` = `value` + 1; SELECT `value` FROM benchmark.cache_innodb WHERE `key` = \'counter\'; UNLOCK TABLES;'
    result = client.query(sql)
    
    values = []
    while client.next_result
      result = client.store_result
      values << result
    end
    values[1].first['value']
  end
end 
