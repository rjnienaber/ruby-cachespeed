class PostgresqlBenchmark < CacheBenchmark
  attr_reader :client
  def initialize(status, counter, logger)
    super
    @client = PG.connect(dbname: 'benchmark', host: '127.0.0.1', port: 5432, user: 'benchmark', password: 'benchmark')
  end

  def reset
    client.exec("TRUNCATE TABLE cache;")
  end

  def execute
    result = client.exec("select upsertism('counter');")
    result.first.values_at('upsertism')[0].to_i
  end
end
