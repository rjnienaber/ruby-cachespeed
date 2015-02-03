class CacheBenchmark
  attr_reader :status, :counter, :thread, :responses, :response_times, :errors, :logger
  
  attr_accessor :ready, :stopped
  def initialize(status, counter, logger)
    @status = status
    @counter = counter
    @logger = logger
    @responses = []
    @response_times = []
    @errors = []
    @ready = false
    @stopped = false
  end

  def warmup
    run
    loop do
      sleep 0.001
      break if ready
      raise 'Benchmark thread died' unless thread.status
    end
    execute
  end

  def run
    @thread = Thread.new do
      begin
        logger.debug "Thread #{counter} waiting"
        self.ready = true
        Thread.stop
        logger.debug "Thread #{counter} started"

        while status.running
          run_benchmark
        end
        logger.debug "Thread #{counter} stopped"
      rescue => e
        logger.debug "Thread-#{counter} died with error: #{e} - #{e.backtrace.join("\n")}"
      ensure
        self.stopped = true  
      end 
    end
  end

  def start
    thread.wakeup
  end

  def stop
    thread.join unless thread.status
    loop do
      sleep 0.001
      break if stopped
    end
  end

  def stats
    {
      responses: responses,
      response_times: response_times,
      errors: errors
    }
  end

  private
  def run_benchmark
    start_time = Time.now          
    result = execute
    end_time = Time.now
    if status.running
      responses << result
      response_times << (end_time - start_time)
    end
  rescue => e    
    errors << e
    raise
  end
end