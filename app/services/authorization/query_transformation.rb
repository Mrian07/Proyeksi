#-- encoding: UTF-8



class Authorization::QueryTransformation
  attr_accessor :on, :name, :after, :before, :block

  def initialize(on,
                 name,
                 after,
                 before,
                 block)

    self.on = on
    self.name = name
    self.after = after
    self.before = before
    self.block = block
  end

  def apply(*args)
    block.call(*args)
  end
end
