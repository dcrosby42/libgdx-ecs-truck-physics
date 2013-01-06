class DebugComponent
  attr_accessor :on, :debug_items

  def self.create(defs=[],opts={})
    dc = DebugComponent.new
    dc.debug_items = defs.map do |(type, func, label)|
      i = Item.new
      i.type = type
      i.func = func
      i.label = label
      i
    end
    dc.on = opts[:on] || true
    dc
  end

  class Item
    attr_accessor :type, :func, :label
  end
end

