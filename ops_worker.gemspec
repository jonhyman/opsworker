lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require "lib/ops_worker/version/version"

Gem::Specification.new do |s|
  s.name        = 'OpsWorker'
  s.version     = OpsWorker::VERSION
  s.date        = '2013-04-13'
  s.summary     = "A simple wrapper for common OpsWorks tasks."
  s.description = "A simple wrapper for common OpsWorks tasks."
  s.authors     = "Jon Hyman"
  s.email       = "jon@appboy.com"
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md Rakefile)
  s.require_path = 'lib'

  s.add_dependency("aws-sdk")
  s.add_development_dependency("rspec")
end
