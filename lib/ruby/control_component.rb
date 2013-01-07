class ControlComponent
  attr_accessor :attr_key_mapping

  def self.create(opts={})
    mapping = opts

    pc = new
    pc.attr_key_mapping = mapping
    mapping.keys.each do |attr_name|
      pc.meta_eval { attr_accessor attr_name }
    end
    pc
  end

end

