require 'blank_screen'

class MyGame < Game
  def create
    self.setScreen(BlankScreen.new)
  end
end
