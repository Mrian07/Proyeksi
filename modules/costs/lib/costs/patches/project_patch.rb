

module Costs::Patches::ProjectPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
    base.include(InstanceMethods)

    base.class_eval do
      has_many :rates, class_name: 'HourlyRate'

      has_many :member_groups, -> {
        includes(:principal)
          .where("#{Principal.table_name}.type='Group'")
      }, class_name: 'Member'
      has_many :groups, through: :member_groups, source: :principal
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def costs_enabled?
      module_enabled?(:costs)
    end
  end
end
