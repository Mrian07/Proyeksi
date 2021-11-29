#-- encoding: UTF-8



class GroupUser < ApplicationRecord
  belongs_to :group,
             touch: true
  belongs_to :user

  validates :group, presence: true
  validates :user, presence: true
end
