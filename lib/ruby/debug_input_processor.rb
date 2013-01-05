
class DebugInputProcessor
  include InputProcessor

  def keyDown(keycode)
    debug "keyDown #{keycode}"
    true
  end

  def keyUp(keycode)
    debug "keyUp #{keycode}"
    true
  end

  def keyTyped(char)
    str = ""
    str << char
    debug "keyTyped #{char.inspect} => #{str.inspect}"
    true
  end

  def mouseMoved(x,y)
    debug "mouseMoved #{x},#{y}"
    false
  end

  def touchDown(x,y,pointer,button)
    debug "touchDown #{x},#{y} pointer=#{pointer.inspect} button=#{button.inspect}"
    false
  end

  def touchUp(x,y,pointer,button)
    debug "touchUp #{x},#{y} pointer=#{pointer.inspect} button=#{button.inspect}"
    false
  end

  def touchDragged(x,y,pointer)
    debug "touchDragged #{x},#{y} pointer=#{pointer.inspect}"
    false
  end

  def scrolled(amount)
    debug "scrolled #{amount}"
    false
  end

  private
  def debug(str)
    puts "DebugInputProcessor: #{str}"
  end
end
