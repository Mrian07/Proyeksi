

class MeetingParticipant < ApplicationRecord
  belongs_to :meeting
  belongs_to :user

  scope :invited, -> { where(invited: true) }
  scope :attended, -> { where(attended: true) }

  def name
    user.present? ? user.name : I18n.t('user.deleted')
  end

  def mail
    user.present? ? user.mail : I18n.t('user.deleted')
  end

  def <=>(other)
    to_s.downcase <=> other.to_s.downcase
  end

  alias :to_s :name

  def copy_attributes
    # create a clean attribute set allowing to attach participants to different meetings
    attributes.reject { |k, _v| ['id', 'meeting_id', 'attended', 'created_at', 'updated_at'].include?(k) }
  end
end
