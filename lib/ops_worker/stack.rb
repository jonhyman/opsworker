module OpsWorker
  class Stack
    attr_reader :id, :name, :region

    def initialize(id, name, region, opsworks_client)
      @id = id
      @name = name
      @region = region
      @opsworks_client = opsworks_client
    end

    def apps
      if @apps
        return @apps
      end

      apps_result = @opsworks_client.describe_apps(:stack_id => @id)[:apps]
      @apps = apps_result.map do |app_hash|
        App.new(app_hash[:app_id], app_hash[:name], app_hash[:app_source][:revision], self, @opsworks_client)
      end
    end

    def layers
      if @layers
        return @layers
      end

      layers_result = @opsworks_client.describe_layers(:stack_id => @id)[:layers]
      @layers = layers_result.map do |layer_hash|
        Layer.new(layer_hash[:layer_id], layer_hash[:name], layer_hash[:type], self, @opsworks_client)
      end
    end

    def to_s
      "#<OpsWorker::Stack #{@id}, #{@name}, #{@region}>"
    end

    def reload
      @layers = nil
      @apps = nil
    end
  end
end
