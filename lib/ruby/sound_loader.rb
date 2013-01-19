class SoundLoader
  construct_with :app

  def initialize
    @sound_cache = {}
  end

  def load_sound(snd_name)
    file = RELATIVE_ROOT + 'res/sounds/' + snd_name
    return @sound_cache[file] if @sound_cache[file]
    handle = Gdx.files.internal(file)
    begin
      sound = app.audio.new_sound(handle)
      @sound_cache[file] = sound
      return sound
    rescue Exception => e
      puts "!! FAIL to load sound using Gdx.files.internal(#{file.inspect}): #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      raise "Aborting due to sound loading difficulties with #{file}"
    end
  end

end
