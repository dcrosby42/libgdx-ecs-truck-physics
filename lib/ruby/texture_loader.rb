class TextureLoader
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
end
