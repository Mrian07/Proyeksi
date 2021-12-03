class EmptyContract < ModelContract
  def initialize(*)
    ;
  end

  def validate
    true
  end
end
