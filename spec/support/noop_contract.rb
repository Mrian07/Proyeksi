#-- encoding: UTF-8



class NoopContract
  def initialize(*_); end

  def validate
    true
  end
end
