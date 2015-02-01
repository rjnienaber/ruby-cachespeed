class MysqlBenchmark < CacheBenchmark
  attr_reader :client
  def initialize(status, counter, logger)
    super
    @client = Mysql2::Client.new(host: "127.0.0.1", username: "root", password: "root", port: 33306, flags: Mysql2::Client::MULTI_STATEMENTS)
  end

  def reset
    client.query("TRUNCATE TABLE benchmark.`cache`;")
  end

  def execute
    sql = 'LOCK TABLES benchmark.`cache` WRITE; INSERT INTO benchmark.`cache` VALUES (\'counter\', 1) ON DUPLICATE KEY UPDATE `value` = `value` + 1; SELECT `value` FROM benchmark.cache WHERE `key` = \'counter\'; UNLOCK TABLES;'
    result = client.query(sql)
    
    values = []
    while client.next_result
      result = client.store_result
      values << result
    end
    values[1].first['value']
  end
end 