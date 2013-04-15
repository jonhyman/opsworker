# opsworker

Quick command line tool for handling servers on OpsWorks.

## Example
```ruby
require 'ops_worker'

client = OpsWorker::Client.new
# or, client = OpsWorker::Client.new(:access_key_id => "foo", :secret_access_key => "bar")
app = client.find_app_by_name("my_app_staging")
app.deploy()
```
