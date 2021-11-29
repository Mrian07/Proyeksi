#-- encoding: UTF-8



class WorkPackage::InexistentWorkPackage < WorkPackage
  _validators.clear

  def does_not_exist
    errors.add :base, :does_not_exist
  end
end
