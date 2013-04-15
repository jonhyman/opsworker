module OpsWorker
  class Layer
    attr_reader :id, :name, :type, :stack

    def initialize(id, name, type, stack, opsworks_client)
      @id = id
      @name = name
      @stack = stack
      @type = type
      @opsworks_client = opsworks_client
    end

    def to_s
      "#<OpsWorker::Layer #{@id}, #{@name}, stack: #{@stack.name}>"
    end
  end
end
