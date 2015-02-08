class MemcacheBenchmark < CacheBenchmark
  attr_reader :client
  
  def initialize(status, counter, logger)
    super
    @client = Dalli::Client.new('127.0.0.1:11210')
    Dalli.logger = logger
  end

  def reset
    client.delete('counter')
  end

  def execute
    client.incr('counter', 1, nil, 1)
  end
end 
