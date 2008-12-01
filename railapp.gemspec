Gem::Specification.new do |s|

  s.platform          = Gem::Platform::RUBY
  s.name              = "railapp"
  s.version           = "1.0.0"
  s.author            = "RailApp"
  s.email             = "railapp@gmail.com"
  s.homepage          = "http://railapp.com/"
  s.summary           = "RailApp: ruby on rails application starter kit"
  s.files             = FileList['lib/*.rb', 'test/*'].to_a
  s.require_path      = "lib"
  s.autorequire       = "railapp"
  s.test_files        = FileList["{test}/**/*test.rb"].to_a
  s.has_rdoc          = true
  #s.extra_rdoc_files  = ["README"]

  dependencies = "

    rubygems-update
    RubyGems is a package manager for distributing Ruby programs and libraries called gems.
    http://www.rubygems.org/
    >=1.3.1

    rake
    Rake is a simple ruby build program with capabilities similar to make.
    http://rake.rubyforge.org/
    >=0.8.3

    rails
    ruby on rails
    http://rubyonrails.com/
    >=2.1.2

    rspec
    RSpec is a Behaviour Driven Development framework for Ruby.
    http://rspec.info/
    >=1.1.11

    rspec-rails
    RSpec is a Behaviour Driven Development framework for Ruby.
    http://rspec.info/
    >=1.1.11

    treetop
    Treetop is a language tool that parses expression grammars to help you analyze syntax.
    http://treetop.rubyforge.org/
    >=1.2.4

    aslakhellesoy-cucumber
    Cucumber is a testing tool that can execute feature documentation written in plain text.
    http://github.com/aslakhellesoy/cucumber/wikis
    >=0.1.10

    hpricot
    Hpricot is a very flexible HTML parser,
    http://code.whytheluckystiff.net/hpricot/
    >=0.6.164

    cheat
    Cheat is a simple command line utility reference program.
    http://cheat.errtheblog.com/
    >=0.0.0

    zentest
    ZenTest bundles tools for unit tests, diff, autotest, multiruby, Test:::Rails.
    http://www.freshports.org/devel/rubygem-zentest/
    >=3.11.0

    hoe
    Hoe is a simple rake/rubygems helper that generates all the usual tasks for projects.
    http://seattlerb.rubyforge.org/hoe/
    >=1.8.2

    authlogic
    AuthLogic is a clean rails restful authentication solution with a gem instead of a generator.
    http://authlogic.rubyforge.org/
    >=1.3.4

    polyglot
    Polyglot provides a registry of file types and custom file loaders to require and process files.
    http://polyglot.rubyforge.org/
    >=0.2.3

    rack
    Rack provides an minimal interface between webservers supporting Ruby and Ruby frameworks.
    http://rack.rubyforge.org/
    >=0.4.0

    json
    JSON implementation for Ruby using fast compiled bindings
    http://json.rubyforge.org/
    >=1.1.3

    json_pure
    JSON implementation for Ruby using pure ruby processing, which is required for JRuby
    http://json.rubyforge.org/
    >=1.1.3

    mocha
    Mocha is a test library to mock and stub using a syntax that works with many test frameworks.
    http://www.workingwithrails.com/rubygem/4606-mocha
    >=0.9.2

    mime-types
    MIME Types manages a MIME Content-Type that will return the Content-Type for a given filename.
    http://mime-types.rubyforge.org/
    >=1.15.0

    highline
    HighLine improves console input/output with error checking, validations, and typecasting.
    http://highline.rubyforge.org/
    >=1.5.0

    rubyinline
    RubyInline enables you to embed code in C, C++, and other languages into your ruby script..
    http://www.zenspider.com/ZSS/Products/RubyInline/
    >=3.8.1

    RedCloth
    RedCloth is a module for using Textile in Ruby, a simple text format for creating HTML.
    http://whytheluckystiff.net/ruby/redcloth/
    >=4.1.1

    Selenium
    Selenium-Ruby bundles the selenium server and Ruby classes in a gem.
    http://selenium.rubyforge.org/getting-started.html
    >=1.1.14

    haml
    Haml helps generating views in your Rails application by improving ERB and HTML
    http://haml.hamptoncatlin.com/
    >=2.0.4

  "
  dependencies = dependencies.strip.gsub(/^ +/,'').split(/\n\n/).map{|x|x.split(/\n/)}

  ##
  # Dependencies to consider for next version:
  #   ruby-debug
  #   webrat
  #   nokogiri
  #   ryanb-acts-as-list
  #   vpim
  #   mislav-will_paginate
  #   rubyforge (1.0.1)
  #   RubyInline (3.8.1)
  #   ryanb-acts-as-list (0.1.2)
  #   term-ansicolor (1.0.3)
  #   abstract (1.0.0)
  #   builder (2.1.2)
  #   diff-lcs (1.1.2)
  #   erubis (2.6.2)
  #   mailfactory (1.4.0)
  #   markaby (0.5)
  #   net-scp (1.0.1)
  #   net-sftp (2.0.1)
  #   net-ssh (2.0.4)
  #   net-ssh-gateway (1.0.0)
  #   rubigen (1.3.4)

  dependencies.each{|d|
    name, uri, desc, version, z = d
    s.add_dependency(name,version)
  }

end
