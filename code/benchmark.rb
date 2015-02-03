require 'thread'
require 'logger'

require 'bundler/setup'
Bundler.require(:default)

require_relative 'lib/cache_benchmark'
Dir['./lib/*.rb'].each { |f| require f}

def parse_options
  Slop.parse(strict: true, help: true) do
    banner 'Usage: benchmark.rb [options]'

    on '-b=', '--benchmark=', 'Benchmark to perform (mysql, memcache, redis, postgres)'
    on '-t=', '--threads=', 'Threads to use (default 10)', default: 10, argument: :optional, as: Integer
    on '-d=', '--duration=', 'Duration in seconds to run benchmark (default 10)', default: 80, argument: :optional, as: Integer
    on '-o=', '--output_file=', 'Output to file', default: 'results.csv', argument: :optional
    on '-l=', '--log_level=', 'Logging level', default: 'info', argument: :optional
  end
end

def create_benchmark(options)
  benchmark = options[:benchmark].downcase
  benchmark_name = benchmark.split('_').map { |s| s[0].upcase + s[1..-1] }.join
  type = Object::const_get("#{benchmark_name}Benchmark")
  BenchmarkPool.new(type, LOGGER, pool_size: options[:threads])
end

def run_benchmark(benchmark, options)
  LOGGER.info "Running benchmark: #{benchmark.type.name.gsub('Benchmark', '')}, (#{options[:duration]}s, #{options[:threads]} threads)"
  benchmark.reset
  start_time = Time.now
  benchmark.start
  sleep options[:duration]
  LOGGER.info "Stopping Benchmark"
  benchmark.stop
  end_time = Time.now
  LOGGER.info "Stopped Benchmark"
  total = end_time - start_time
  BenchmarkResults.new(options[:benchmark], options[:threads], total, benchmark.stats)
end

def output_results(options, benchmark, results)
  LOGGER.info "RESULTS: #{benchmark.type.name.gsub('Benchmark', '')}, (#{options[:duration]}s, #{options[:threads]} threads)"
  LOGGER.info "Successful Responses: #{results.response_count}"  
  LOGGER.info "Errors: #{results.errors.length}"
  LOGGER.info "Valid?: #{results.valid?}"
  LOGGER.info "Missing: #{results.missing[0..9]}#{results.missing.length > 10 ? '...' : ''} (#{results.missing.length})" unless results.valid?
  LOGGER.info "Duration: #{results.duration.round(2)}"
  LOGGER.info "Requests/sec: #{results.requests_per_sec.round(2)}"
  LOGGER.info "Median: #{results.median.round(2)} (ms)"
  LOGGER.info "95%: #{results.ninety_five_percentile.round(2)} (ms)"
  LOGGER.info "99%: #{results.ninety_nine_percentile.round(2)} (ms)"
end

options = parse_options

LOGGER = Logger.new(STDOUT)
LOGGER.level = Object::const_get("Logger::#{options[:log_level].upcase}")

benchmark = create_benchmark(options)
results = run_benchmark(benchmark, options)
results.save(options[:output_file])
output_results(options, benchmark, results)
