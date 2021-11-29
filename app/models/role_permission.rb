#-- encoding: UTF-8



class RolePermission < ApplicationRecord
  belongs_to :role

  validates_presence_of :permission
end
