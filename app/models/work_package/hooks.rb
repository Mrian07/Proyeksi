#-- encoding: UTF-8

module WorkPackage::Hooks
  extend ActiveSupport::Concern

  included do
    after_commit :call_after_create_hook, on: :create
    after_commit :call_after_update_hook, on: :update
  end

  def call_after_create_hook
    context = { work_package: self }

    ProyeksiApp::Hook.call_hook :work_package_after_create, context
  end

  def call_after_update_hook
    context = { work_package: self }

    ProyeksiApp::Hook.call_hook :work_package_after_update, context
  end
end
