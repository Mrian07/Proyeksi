#-- encoding: UTF-8



class WorkPackages::CopyService
  include ::Shared::ServiceContext
  include Contracted

  attr_accessor :user,
                :work_package,
                :contract_class

  def initialize(user:, work_package:, contract_class: WorkPackages::CreateContract)
    self.user = user
    self.work_package = work_package
    self.contract_class = contract_class
  end

  def call(send_notifications: true, **attributes)
    in_context(work_package, send_notifications) do
      copy(attributes, send_notifications)
    end
  end

  protected

  def copy(attribute_override, send_notifications)
    attributes = copied_attributes(work_package, attribute_override)

    copied = create(attributes, send_notifications)

    if copied.success?
      remove_author_watcher(copied.result)
      copy_watchers(copied.result)
    end

    copied.state.copied_from_work_package_id = work_package&.id

    copied
  end

  def create(attributes, send_notifications)
    WorkPackages::CreateService
      .new(user: user,
           contract_class: contract_class)
      .call(**attributes.merge(send_notifications: send_notifications).symbolize_keys)
  end

  def copied_attributes(wp, override)
    wp
      .attributes
      .slice(*writable_work_package_attributes(wp))
      .merge('parent_id' => wp.parent_id,
             'custom_field_values' => wp.custom_value_attributes)
      .merge(override)
  end

  def writable_work_package_attributes(wp)
    instantiate_contract(wp, user).writable_attributes
  end

  def remove_author_watcher(copied)
    copied.remove_watcher(copied.author)
  end

  def copy_watchers(copied)
    work_package.watcher_users.each do |user|
      copied.add_watcher(user) if user.active?
    end
  end
end
