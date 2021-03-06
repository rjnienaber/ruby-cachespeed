class BenchmarkPool
  attr_reader :type, :pool_size, :status, :pool, :mutex

  def initialize(type, logger, pool_size=10)
    @type = type
    @pool_size = pool_size || 10
    @status = Struct.new(:running).new(true)  

    @pool = (1..@pool_size).map { |i| type.new(@status, i, logger)}
  end

  def warmup
    t = pool.map { |b| Thread.new { b.warmup }}
    t.each(&:join)
  end

  def reset
    pool.first.reset
  end

  def start
    pool.each(&:start)
  end

  def stop
    status.running = false
    pool.each(&:stop)
  end

  def stats
    pool.map(&:stats)
  end
end
