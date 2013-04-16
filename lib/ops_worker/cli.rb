require 'trollop'

module OpsWorker
  class CLI
    def self.start
      client = OpsWorker::Client.new

      sub_commands = ["deploy", "rollback", "update_cookbooks", "execute_recipe"]
      opts = Trollop::options do
        banner "ops_worker AWS OpsWorks helper"
        opt :app, "Application", :type => :string, :short => :a, :required => true
        stop_on sub_commands
      end

      command = ARGV.shift()

      app = client.find_app_by_name(opts[:app])

      case command
        when "deploy"
          command_opts = Trollop::options do
            opt :branch, "Branch", :type => :string
          end
          app.deploy(command_opts[:branch])
        when "rollback"
          app.rollback()
        when "update_cookbooks"
          app.update_cookbooks()
        when "execute_recipe"
          command_opts = Trollop::options do
            opt :recipe_name, "Recipe name", :type => :string, :required => true
          end
          app.execute_recipes([command_opts[:recipe_name]])
        else
          Trollop::die("Unknown command #{command}")
      end
    end
  end
end
