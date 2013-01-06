require 'warbler'
Warbler::Task.new

task :default do
  puts 
  puts "Instead:  ./run.sh"
  puts
  exit 1
end

# task :bounce do
#   sh "ruby -J-Djava.library.path=./native -rubygems bouncing_ball.rb"
# end
namespace :build do
  desc "Build Truck2.app for OS X"
  task :app => "jar" do
    app_template = "installer/osx/Truck2_app_template"
    app = "Truck2.app"
    javaroot = "#{app}/Contents/Resources/Java"
    jar = "libgdx_practice.jar"

    rm_rf app
    cp_r app_template, app
    cp jar, javaroot
  end
end

