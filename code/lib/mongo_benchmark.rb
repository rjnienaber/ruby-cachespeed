class MongoBenchmark < CacheBenchmark
  attr_reader :client
  def initialize(status, counter, logger)
    super
    @client = Mongo::MongoClient.new
  end

  def reset
    client['benchmark']['cache'].remove
  end

  def execute
    client['benchmark']['cache'].find_and_modify(update: { '$inc' => { counter: 1 } }, upsert: true, :new => true)['counter']
  end
end 
