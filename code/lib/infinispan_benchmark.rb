if RUBY_ENGINE == 'jruby'
  require_relative '../java_lib/spymemcached-2.11.6.jar'
  java_import 'net.spy.memcached.MemcachedClient'
  java_import 'java.net.InetSocketAddress'
end

class InfinispanBenchmark < CacheBenchmark
  attr_reader :client
  
  def initialize(status, counter, logger)
    super
    @client = MemcachedClient.new(InetSocketAddress.new('127.0.0.1', 11211))
  end

  # running on java so we need to give 
  # the JIT time to optimise
  def warmup
    super

    warmup_time = 60

    logger.info "Warming up JIT on JRuby for #{warmup_time} seconds"
    end_time = Time.now + warmup_time
    loop do
      execute
      break if Time.now > end_time
    end
    logger.info "Finished warming up JIT"
  end

  def reset
    client.delete('counter').get #this is a future operation
  end

  def execute
    client.incr('counter', 1, 1, 60000)
  end
end
