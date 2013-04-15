module OpsWorker
  class DeploymentStatus
    def initialize(id, opsworks_client)
      @id = id
      @opsworks_client = opsworks_client
    end

    def status
      commands().map {|c| c[:status] }
    end

    private
    def commands
      @opsworks_client.describe_commands(:deployment_id => @id)[:commands]
    end
  end
end
