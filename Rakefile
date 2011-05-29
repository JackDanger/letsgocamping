Rake.application.options.trace = true

require File.expand_path File.join(File.dirname(__FILE__), 'lib', 'recreation')

namespace :build do
  desc "Build the whole project"
  task :all do
    Recreation.process! :html
  end
end


task :irb do
  exec "irb -rubygems -I'lib' -r recreation"
end
