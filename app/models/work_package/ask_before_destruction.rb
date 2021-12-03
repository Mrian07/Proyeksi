#-- encoding: UTF-8

module WorkPackage::AskBeforeDestruction
  extend ActiveSupport::Concern

  DestructionRegistration = Struct.new(:klass, :check, :action)

  def self.included(base)
    base.extend(ClassMethods)

    base.class_attribute :registered_associated_to_ask_before_destruction
  end

  module ClassMethods
    def cleanup_action_required_before_destructing?(work_packages)
      !associated_to_ask_before_destruction_of(work_packages).empty?
    end

    def cleanup_associated_before_destructing_if_required(work_packages, user, to_do = { action: 'destroy' })
      cleanup_required = cleanup_action_required_before_destructing?(work_packages)

      (!cleanup_required ||
        (cleanup_required &&
          cleanup_each_associated_class(work_packages, user, to_do)))
    end

    def associated_classes_to_address_before_destruction_of(work_packages)
      associated = []

      registered_associated_to_ask_before_destruction.each do |registration|
        associated << registration.klass if registration.check.call(work_packages)
      end

      associated
    end

    private

    def associated_to_ask_before_destruction_of(work_packages)
      associated = {}

      registered_associated_to_ask_before_destruction.each do |registration|
        associated[registration.klass] = registration.action if registration.check.call(work_packages)
      end

      associated
    end

    def associated_to_ask_before_destruction(klass, check, action)
      self.registered_associated_to_ask_before_destruction ||= []

      registration = DestructionRegistration.new(klass, check, action)

      self.registered_associated_to_ask_before_destruction << registration
    end

    def cleanup_each_associated_class(work_packages, user, to_do)
      ret = false

      transaction do
        associated_to_ask_before_destruction_of(work_packages).each do |_klass, method|
          ret = method.call(work_packages, user, to_do)
        end

        raise ActiveRecord::Rollback unless ret
      end

      ret
    end
  end
end
