require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

RAILS_ENV = 'test'
RAILS_ROOT = File.dirname(__FILE__)

desc 'Default: run unit tests.'
task :default => :test

task :environment do
  require(File.join(RAILS_ROOT, 'config', 'environment'))
end

desc 'Test all units and functionals'
task :test do
  Rake::Task["test:units"].invoke       rescue got_error = true
  Rake::Task["test:functionals"].invoke rescue got_error = true
end

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  STATS_DIRECTORIES = [
    %w(Libraries          lib/),
    %w(Functional\ tests  test/functional),
    %w(Unit\ tests        test/unit)
  ].collect { |name, dir| [ name, "#{RAILS_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }
  require 'code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end

namespace :db do
  namespace :test do
    desc 'Prepare the test database and load the schema'
    task :prepare => :environment do
      config = YAML::load(IO.read(File.join(RAILS_ROOT, 'config', 'database.yml')))
      ActionController::Base.logger = ActiveRecord::Base.logger = Logger.new(File.join(RAILS_ROOT, 'log', "#{RAILS_ENV}.log"))
      ActiveRecord::Base.establish_connection(config[RAILS_ENV])
      # Only rebuild the database if it doesn't exist (presumes sqlite3).
      unless File.exist?(config[RAILS_ENV][:dbfile])
        load(File.join(RAILS_ROOT, 'db', 'schema.rb')) 
      end
    end 
  end
end

namespace :test do
  desc 'Run the unit tests in test/unit'
  Rake::TestTask.new(:units => "db:test:prepare") do |t|
    t.libs << 'lib'
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = true    
  end

  desc 'Run the functional tests in test/functional'
  Rake::TestTask.new(:functionals => "db:test:prepare") do |t|
    t.libs << 'lib'
    t.pattern = 'test/functional/*_test.rb'
    t.verbose = true    
  end

  desc 'Measures test coverage'
  task :coverage do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
    system("#{rcov} --no-html test/unit/*_test.rb")
    system("#{rcov} --html test/functional/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end

namespace :doc do
  desc 'Generate documentation for the assert_request plugin.'
  Rake::RDocTask.new(:plugin) do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title    = 'AssertRequest'
    rdoc.options << '--line-numbers' << '--inline-source' << '--accessor' << 'cattr_accessor=rw'
    rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
end