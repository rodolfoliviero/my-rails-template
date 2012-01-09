class Template < Thor::Group
  include Thor::Actions

  def self.source_root
    File.join File.dirname(__FILE__), "templates"
  end

  def clear
    run "rm README.rdoc"
    run "touch README.textile"
    run "rm -rf test"
    run "rm public/index.html"
    run "rm app/assets/images/rails.png"
  end

  def application_layout
    run "rm app/views/layouts/application.html.erb"
    copy_file "application.html.haml", "app/views/layouts/application.html.haml"
  end

  def db
    run "rm config/database.yml"
    copy_file "database.yml", "config/database.yml"
  end

  def js
    run "rm app/assets/javascripts/application.js"
    copy_file "application.js", "app/assets/javascripts/application.js"
  end

  def gemfile
    run "rm Gemfile"
    copy_file "Gemfile"
  end
  
  def devise_support
    copy_file "devise.rb", "spec/support/devise.rb"
  end
  
  def guard
    copy_file "Guardfile"
  end
end

application  <<-GENERATORS
config.generators do |g|
  g.stylesheets false
  g.javascripts false
  g.template_engine :haml
  g.test_framework  :rspec, :fixture => true, :views => false
  g.integration_tool :rspec, :fixture => true, :views => false
  g.fixture_replacement :factory_girl, :dir => "spec/factories"
end
GENERATORS

Template.new.invoke_all

generate "rspec:install"
generate "simple_form:install"
generate "devise:install"

git :init

puts "THE END"
