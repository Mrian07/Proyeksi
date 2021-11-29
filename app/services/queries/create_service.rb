#-- encoding: UTF-8



class Queries::CreateService < Queries::BaseService
  def initialize(**args)
    super(**args)
    self.contract_class = Queries::CreateContract
  end

  def call(query)
    remove_invalid_order(query)
    super
  end

  private

  def remove_invalid_order(query)
    # Check which of the work package IDs exist
    ids = query.ordered_work_packages.map(&:work_package_id)
    existent_wps = WorkPackage.where(id: ids).pluck(:id).to_set

    query.ordered_work_packages = query.ordered_work_packages.select do |order_item|
      existent_wps.include?(order_item.work_package_id)
    end
  end

  def service_result(result, errors, query)
    query.update user: user

    super
  end
end
