#-- encoding: UTF-8

class Notifications::CreateService < ::BaseServices::Create
  protected

  def persist(service_result)
    super
  rescue ActiveRecord::InvalidForeignKey
    service_result.success = false
    service_result.errors.add(:journal_id, :does_not_exist)
    service_result
  end
end
