class RedisBenchmark < CacheBenchmark
  attr_reader :client
  
  def initialize(status, counter, logger)
    super
    @client = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 15) 
  end

  def reset
    client.del('counter')
  end

  def execute
    client.incr('counter')
  end

end
