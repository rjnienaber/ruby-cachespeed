class BenchmarkResults
  attr_reader :type, :pool_size, :results, :duration
  
  def initialize(type, pool_size, duration, results)
    @type = type
    @pool_size = pool_size
    @duration = duration
    @results = results
  end

  def save(file_path)
    write_header = !File.exists?(file_path)
    File.open(file_path, 'a') do |file|
      file.write("#type,threads,duration_in_seconds,response_count,requests_per_second,mean,50%,95%,99%,std_dev,error_count,valid,missing\n") if write_header
      file.write("#{type},#{pool_size},#{duration},#{response_count},#{requests_per_sec},#{mean},#{median},#{ninety_five_percentile},#{ninety_nine_percentile},#{std_dev},#{errors.length},#{valid?},#{missing.length}\n")
    end
  end

  def response_count
    response_times_in_ms.length
  end

  def mean
    @mean ||= response_times_in_ms.mean
  end

  def median
    @median ||= response_times_in_ms.median
  end

  def ninety_five_percentile
    @ninety_five_percentile ||= response_times_in_ms.percentile(95)
  end

  def ninety_nine_percentile
    @ninety_nine_percentile ||= response_times_in_ms.percentile(99)
  end

  def std_dev
    @std_dev ||= response_times_in_ms.standard_deviation
  end

  def requests_per_sec
    response_times_in_ms.length / duration.to_f
  end

  def response_times_in_ms
    @response_times_in_ms ||= results.map { |r| r[:response_times] }.flatten.map { |s| s * 1000 }
  end

  def errors
    @errors ||= results.map { |r| r[:errors] }.flatten
  end

  def valid?
    missing.empty?
  end

  def missing
    @missing ||= (1..values.max).to_a - values
  end

  private
  def responses
    @responses ||= results.map { |r| r[:responses] }.flatten
  end

  def values
    responses.select { |r| r.is_a?(Fixnum)}
  end
end