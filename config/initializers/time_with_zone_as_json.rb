

class ActiveSupport::TimeWithZone
  def as_json(_options = {})
    time.strftime('%m/%d/%Y/ %H:%M %p').to_s
  end
end
