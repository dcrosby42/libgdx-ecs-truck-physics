class TitleScreen
  include Screen

  def show
  end

  def render(delta)
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
  end

  def hide
  end

  def resize(w,h)
  end

  def pause
  end

  def resume
  end

  def dispose
  end
end
