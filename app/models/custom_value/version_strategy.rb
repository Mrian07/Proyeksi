#-- encoding: UTF-8

class CustomValue::VersionStrategy < CustomValue::ARObjectStrategy
  private

  def ar_class
    Version
  end

  def ar_object(value)
    Version.find_by(id: value)
  end
end
