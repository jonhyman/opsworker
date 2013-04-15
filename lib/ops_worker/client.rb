require 'aws-sdk'

module OpsWorker
  class Client
    def initialize(options = {})
      @opsworks_client = AWS::OpsWorks.new(options).client
    end

    def find_app_by_name(name)
      stacks().each do |stack|
        app = stack.apps.detect {|a| a.name == name}

        if app
          return app
        end
      end

      return nil
    end

    def stacks
      if @stacks
        return @stacks
      end

      stacks = @opsworks_client.describe_stacks()[:stacks]
      @stacks = stacks.map do |stack_hash|
        Stack.new(stack_hash[:stack_id], stack_hash[:name], stack_hash[:region], @opsworks_client)
      end
    end

    def reload
      @stacks = nil
    end

    def method_missing(method_name, *args, &block)
      @opsworks_client.__send__(method_name, *args, &block)
    end
  end
end
