require 'my_game'
require 'file_watcher'

class AppShell
  def launch_game
    @game_width = 800
    @game_height = 600

    @config = LwjglApplicationConfiguration.new
    @config.title = "Truck 2"
    @config.useGL20 = true
    @config.width = @game_width
    @config.height = @game_height

    @watcher = FileWatcher.new
    @watcher.on_file_changed do |fname,mtime|
      puts "Change detected to #{fname} @ #{mtime}"
      reload_game_screen
    end
    @watcher.start

    @game = MyGame.new
    @app = LwjglApplication.new(@game, @config)


    @screen_opts = {
      app_shell: self,
      game_width: @game_width,
      game_height: @game_height,
    }

    @target_screen_source_name = "sandbox_screen"
    require @target_screen_source_name
    @target_screen_class = SandboxScreen

    reload_game_screen
  end

  def reload_game_screen
    puts "Reload #{@target_screen_class}!"
    @app.post_runnable do
      begin
        load_source(@target_screen_source_name)
        @target_screen_class.source_dependencies.each do |dep|
          load_source(dep)
        end
        EntityBuilder.source_dependencies.each do |dep|
          load_source(dep)
        end
        @screen = @target_screen_class.new(@screen_opts)
        @game.set_screen @screen
      rescue Exception => e
        debug_exception e
        # puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      end
    end
  end

  def load_source(name)
    fname = lookup_source(name)
    @watcher.watch_for_mods fname
    load fname
  end

  def lookup_source(name)
    fname = "lib/ruby/#{name}.rb"
    if File.exists?(fname)
      fname
    else
      raise("Can't see source file #{fname}")
    end
  end


  def load_sound(snd_name)
    @sound_cache ||= {}
    file = RELATIVE_ROOT + 'res/sounds/' + snd_name
    return @sound_cache[file] if @sound_cache[file]
    handle = Gdx.files.internal(file)
    begin
      sound = @app.audio.new_sound(handle)
      @sound_cache[file] = sound
      return sound
    rescue Exception => e
      puts "!! FAIL to load sound using Gdx.files.internal(#{file.inspect}): #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      raise "Aborting due to sound loading difficulties with #{file}"
    end
  end

end
