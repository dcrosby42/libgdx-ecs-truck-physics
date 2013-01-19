class BlankScreen
  include Screen

  def initialize(opts={})
  end

  def show
  end

  def render(delta)
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
    
    if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      Gdx.app.exit
    end
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
