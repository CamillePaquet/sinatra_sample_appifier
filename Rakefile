require 'carioca/rake/manage'
require 'rspec/core/rake_task'
require 'rake/clean'
require 'fixturizer/rake/manage'
require './app'

CLEAN.include('*.tmp', '*.old', '*~')
CLOBBER.include('*.tmp', 'build/*', '#*#')

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

namespace :database do
  desc 'Clean MongoDB database'
  task :drop do
    Rake::Task['fixturizer:database:drop'].invoke
  end
  desc 'Populate database'
  task :populate do
    Rake::Task['fixturizer:database:populate'].invoke
  end
end
