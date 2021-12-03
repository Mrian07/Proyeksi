#-- encoding: UTF-8

class CustomValue::UserStrategy < CustomValue::ARObjectStrategy
  private

  def ar_class
    Principal
  end

  def ar_object(value)
    Principal.find_by(id: value)
  end
end
