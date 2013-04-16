# opsworker

Quick command line tool for handling servers on OpsWorks.

## Installation
    gem install ops_worker

## Command Line Example
    ops_worker --app homepage_staging deploy
    ops_worker --app homepage_staging deploy --branch feature/new-feature
    ops_worker --app homepage_staging rollback
    ops_worker --app homepage_staging update_cookbooks
    ops_worker --app homepage_staging execute_recipe --recipe-name monit
    ops_worker --app homepage_staging restart

## Ruby Example
```ruby
require 'ops_worker'

# Initialize using the default AWS.config. You can optionally initialize like
# client = OpsWorker::Client.new(:access_key_id => "foo", :secret_access_key => "bar")
client = OpsWorker::Client.new

# Get a list of all stacks; this will be cached until you call #reload
client.stacks
# => [#<OpsWorker::Stack f1735a57-51c3-4933-8440-4f7beb2cb2ff, homepage_staging, us-east-1>]

# Iterates through all your stacks to find the app named "homepage_staging"
# Alternatively, you can do client.stacks.each {|s| s.apps.each {|a| ... } }
app = client.find_app_by_name("homepage_staging")
app.instances.each do |instance|
  puts("#{instance.name} is online: #{instance.online?}")
end

# Deploy the current revision branch set
app.deploy()

# Switches the current revision branch to feature/new, deploys, then switches it back
app.deploy("feature/new")

app.update_cookbooks()

app.execute_recipes(["monit"])

app.rollback()

app.restart()

client.reload()

client.stacks
# => [#<OpsWorker::Stack f1735a57-51c3-4933-8440-4f7beb2cb2ff, homepage_staging, us-east-1>,
 #<OpsWorker::Stack 3bf98404-dafc-45c4-9fa2-a17485aba4ec, homepage_production, us-east-1>]

# Method missing is delegated to an AWS::OpsWork::Client, so you can use any method from
# http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/OpsWorks/Client.html
client.describe_deployments(:app_id => app.id)
```
