require File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/environment") 
require 'pry'
require 'app_shell'

def load_texture(img_name)
  file = RELATIVE_ROOT + 'res/images/' + img_name
  handle = Gdx.files.internal(file)
  begin
    return Texture.new(handle)
  rescue Exception => e
    puts "!! FAIL to load Texture using Gdx.files.internal(#{file.inspect}): #{e.message}\n\t#{e.backtrace.join("\n\t")}"
    raise "Aborting due to textture loading difficulties with #{file}"
  end
end


# def load_sound(snd_name)
#   $app_shell.load_sound(snd_name)
# end


def debug_exception(e)
  puts "EXCEPTION: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
end


# def get_truck
#   $screen.instance_variable_get(:@entity_manager).get_all_components_of_type(TruckComponent).first
# end

app_shell = AppShell.new
app_shell.launch_game

# $app_shell = app_shell


# require 'pry'
# binding.pry
puts "THE END"


