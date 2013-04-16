module OpsWorker
  class App
    attr_reader :id, :stack, :name, :revision

    def initialize(id, name, revision, stack, opsworks_client)
      @id = id
      @name = name
      @stack = stack
      @revision = revision
      @opsworks_client = opsworks_client
    end

    def instances
      if @instances
        return @instances
      end

      instances_result = @opsworks_client.describe_instances(:stack_id => @stack.id, :app_id => @id)[:instances]
      @instances = instances_result.map do |instance_hash|
        layers = @stack.layers.select {|l| instance_hash[:layer_ids].include?(l.id)}
        Instance.new(instance_hash[:instance_id],
                     instance_hash[:hostname],
                     instance_hash[:status],
                     instance_hash[:instance_type],
                     instance_hash[:elastic_ip],
                     instance_hash[:availability_zone],
                     self,
                     layers)
      end
    end

    # Updates the revision in this app such that all future deploys pull from this revision
    # @param revision String revision to update, e.g., "feature/foo" or "d6053592ee39e64c5f092b0ba6e9cd1aa8334828"
    def update_revision(revision)
      OpsWorker.logger.info {"Changing revision from #{@revision} to #{revision} for app #{@name}"}

      @opsworks_client.update_app(:app_id => @id, :app_source => {:revision => revision})
      @revision = revision
      reload()
    end

    # @param revision String revision to deploy, e.g., "feature/foo" or "d6053592ee39e64c5f092b0ba6e9cd1aa8334828"
    def deploy(revision = nil)
      OpsWorker.logger.info {"Deploying app #{@name} from #{revision || @revision}"}

      existing_revision = @revision.dup()
      changing_revisions = revision && revision != existing_revision

      if changing_revisions
        update_revision(revision)
      end

      deployment_status = create_deployment(:deploy)

      if changing_revisions
        update_revision(existing_revision)
      end

      deployment_status
    end

    def rollback
      OpsWorker.logger.info {"Rolling back #{@name}"}
      create_deployment(:rollback)
    end

    def restart
      OpsWorker.logger.info {"Restarting #{@name}"}
      create_deployment(:restart)
    end

    def update_cookbooks
      OpsWorker.logger.info {"Updating cookbooks for #{@name}"}
      create_deployment(:update_custom_cookbooks, {}, :all)
    end

    # @param recipe_names Array of string recipe names, e.g., ["custom::recipe1"]
    def execute_recipes(recipe_names)
      OpsWorker.logger.info {"Executing recipes #{recipe_names} on #{@name}"}
      create_deployment(:execute_recipes, {"recipes" => recipe_names}, :all)
    end

    def to_s
      "#<OpsWorker::App #{@id}, #{@name}, stack: #{@stack.name}>"
    end

    def reload
      @instances = nil
    end

    private
    # @param instance_category Symbol, :all or :app_servers
    def create_deployment(deployment_name, args = {}, instance_category = :app_servers)
      case instance_category
        when :all
          instances = online_instances()
        when :app_servers
          instances = app_server_instances()
        else
          raise ArgumentError.new("Unknown instance category argument: #{instance_category}")
      end
      instance_ids = instances.map(&:id)
      result = @opsworks_client.create_deployment(:stack_id => @stack.id,
                                                  :app_id => @id,
                                                  :command => {:args => args, :name => deployment_name.to_s()},
                                                  :instance_ids => instance_ids
      )
      DeploymentStatus.new(result[:deployment_id], @opsworks_client)
    end

    def app_server_instances
      online_instances().select do |i|
        i.layers.any? {|l| l.type == "rails-app" || l.type == "custom"}
      end
    end

    def online_instances
      instances().select {|i| i.online?}
    end
  end
end
