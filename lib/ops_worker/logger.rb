require 'logger'

module OpsWorker
  def self.logger
    if @logger.nil?
      @logger = Logger.new(STDOUT)
    end

    @logger
  end

  def self.logger=(val)
    @logger = val
  end
end
