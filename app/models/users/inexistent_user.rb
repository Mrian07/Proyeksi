#-- encoding: UTF-8

class Users::InexistentUser < User
  def self.sti_name
    nil
  end
end
