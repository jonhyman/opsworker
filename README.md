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

## Ruby Example
```ruby
require 'ops_worker'

client = OpsWorker::Client.new
# or, client = OpsWorker::Client.new(:access_key_id => "foo", :secret_access_key => "bar")

pp client.stacks
# => [#<OpsWorker::Stack f1735a57-51c3-4933-8440-4f7beb2cb2ff, homepage_staging, us-east-1>,
 #<OpsWorker::Stack 3bf98404-dafc-45c4-9fa2-a17485aba4ec, homepage_production, us-east-1>]

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
```
