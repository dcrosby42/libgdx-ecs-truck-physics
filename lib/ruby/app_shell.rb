require 'my_game'
require 'file_watcher'

class AppShell
  attr_reader :game_width, :game_height, :context

  def launch_game!(opts={})
    @reloadable = opts[:reloadable] == true

    @context = Conject.create_object_context(nil)
    @context[:app_shell] = self

    @game_width = 800
    @game_height = 600

    @config = LwjglApplicationConfiguration.new
    @config.title = "Truck 2"
    @config.useGL20 = true
    @config.width = @game_width
    @config.height = @game_height

    if @reloadable 
      @watcher = FileWatcher.new
      @watcher.on_file_changed do |fname,mtime|
        puts "Change detected to #{fname} @ #{mtime}"
        reload_game_screen
      end
      @context[:file_watcher] = @watcher
    end

    @game = MyGame.new
    @context[:game] = @game#MyGame.new
    @app = LwjglApplication.new(@game, @config)
    @context[:app] = @app

    # @screen_opts = {
    #   app_shell: self,
    #   game_width: @game_width,
    #   game_height: @game_height,
    # }

    @target_screen_source_name = "sandbox_screen"
    require @target_screen_source_name
    @target_screen_class = SandboxScreen
    #@context.configure_objects @target_screen_source_name => { cache: false }

    reload_game_screen

    @watcher.start if @reloadable
  end

  def prompt
    require 'pry'
    binding.pry
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
        
        @context.in_subcontext do |sub| 
          @screen = sub[@target_screen_source_name]
        end
        @game.set_screen @screen
      rescue Exception => e
        debug_exception e
        # puts "RELOAD FAIL: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      end
    end
  end

  def load_source(name)
    if @reloadable
      fname = lookup_source(name)
      @watcher.watch_for_mods fname
      load fname
    else
      require name
    end
  end

  def lookup_source(name)
    fname = "lib/ruby/#{name}.rb"
    if File.exists?(fname)
      fname
    else
      raise("Can't see source file #{fname}")
    end
  end


end
