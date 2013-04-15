module OpsWorker
  class Instance
    attr_reader :id, :hostname, :status, :app, :layers, :elastic_ip, :instance_type, :availability_zone

    def initialize(id, hostname, status, instance_type, elastic_ip, availability_zone, app, layers)
      @id = id
      @hostname = hostname
      @status = status
      @instance_type = instance_type
      @elastic_ip = elastic_ip
      @availability_zone = availability_zone
      @app = app
      @layers = layers
    end

    def stopped?
      @status == "stopped"
    end

    def online?
      @status == "online"
    end

    def to_s
      "#<OpsWorker::Instance #{@id}, host: #{@hostname}, status: #{@status}, type: #{@instance_type}, layers: #{@layers.map(&:name)}>"
    end
  end
end
