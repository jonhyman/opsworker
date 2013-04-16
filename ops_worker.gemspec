$LOAD_PATH << File.dirname(__FILE__)
require "lib/ops_worker/version"

Gem::Specification.new do |s|
  s.name         = 'ops_worker'
  s.version      = OpsWorker::VERSION
  s.date         = '2013-04-13'
  s.summary      = "A simple wrapper for common OpsWorks tasks."
  s.description  = "A simple wrapper for common OpsWorks tasks."
  s.authors      = "Jon Hyman"
  s.email        = "jon@appboy.com"
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'
  s.homepage     = 'https://github.com/jonhyman/opsworker'
  s.executables << 'ops_worker'

  s.add_dependency("aws-sdk")
  s.add_dependency("trollop")
  s.add_development_dependency("rspec")
end
