
class MyInputProcessor < InputAdapter
  attr_reader :keys_down, :keys_up, :keys_typed

  def initialize
    @keys_down = []
    @keys_up = []
    @keys_typed = []
    clear
  end

  def clear
    @keys_down.clear
    @keys_up.clear
    @keys_typed.clear
  end

  def keyDown(keycode)
    @keys_down << keycode
    true
  end

  def keyUp(keycode)
    @keys_up << keycode
    true
  end

  def keyTyped(char)
    @keys_typed << char
    true
  end

  def key_pressed?(keycode)
    @keys_down.include?(keycode)
  end

  def key_released?(keycode)
    @keys_up.include?(keycode)
  end

  def key_down?(keycode)
    Gdx.input.isKeyPressed keycode
  end
end
