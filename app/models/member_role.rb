#-- encoding: UTF-8



class MemberRole < ApplicationRecord
  belongs_to :member, touch: true
  belongs_to :role

  validates_presence_of :role
  validate :validate_project_member_role

  def validate_project_member_role
    errors.add :role_id, :invalid if role && !role.member?
  end

  def inherited?
    !inherited_from.nil?
  end
end
