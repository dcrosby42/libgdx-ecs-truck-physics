
class Ball
  include Screen

  def initialize
    # puts "!! INITIALIZE !!"
  end

  def show
    # puts "!! SHOW !!"
    @BOX_STEP = 1.0/60  
    @BOX_VELOCITY_ITERATIONS = 6  
    @BOX_POSITION_ITERATIONS = 2  
    # @WORLD_TO_BOX = 0.01
    # @BOX_WORLD_TO = 100  

    @world = World.new(Vector2.new(0,-100), true)
    @debug_renderer = Box2DDebugRenderer.new
    @camera = OrthographicCamera.new
    @camera.viewportWidth = $game_width
    @camera.viewportHeight = $game_height
    @camera.position.set(@camera.viewportWidth * 0.5, @camera.viewportHeight * 0.5, 0)
    @camera.update

    #Ground body  
    @groundBodyDef = BodyDef.new
    @groundBodyDef.position.set(Vector2.new(0, 10))  
    @groundBody = @world.createBody(@groundBodyDef)  
    @groundBox = PolygonShape.new
    @groundBox.setAsBox((@camera.viewportWidth) * 2, 10.0)  
    @groundFixture = @groundBody.createFixture(@groundBox, 0.0)  
    @groundFixture.friction = 1


    #Dynamic Body  
    3.times do |i|
      @bodyDef = BodyDef.new
      @bodyDef.type = BodyDef::BodyType::DynamicBody  
      @bodyDef.position.set((@camera.viewportWidth / 2) + (i*20), (@camera.viewportHeight / 2) + (i*20))  
      @body = @world.createBody(@bodyDef)  
      @dynamicCircle = CircleShape.new
      @dynamicCircle.setRadius(20)  
      @fixtureDef = FixtureDef.new
      @fixtureDef.shape = @dynamicCircle  
      @fixtureDef.density = 3
      @fixtureDef.friction = 1.0  
      @fixtureDef.restitution =0.5 
      @body.createFixture(@fixtureDef)  
    end
  end

  def hide
  end

  def render(d)
    # puts "!! RENDER #{d} !!"
    Gdx.gl.glClear(GL10::GL_COLOR_BUFFER_BIT);  
    @debug_renderer.render(@world, @camera.combined);  
    @world.step(@BOX_STEP, @BOX_VELOCITY_ITERATIONS, @BOX_POSITION_ITERATIONS);  

    if Gdx.input.isKeyPressed(Input::Keys::BACKSLASH)
      reload_ball
      # puts "HI!"
      # require 'pry'
      # binding.pry
    end

    if Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      # @game.setScreen StartupState.new(@game)
      Gdx.app.exit
    end
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
