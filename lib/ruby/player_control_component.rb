class PlayerControlComponent
  attr_accessor :attr_key_mapping,
    :left, :right, :jump, :boost

  def self.create(opts={})
    pc = new
    pc.attr_key_mapping = opts
    pc
  end

end

