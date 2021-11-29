#-- encoding: UTF-8



module SingleTableInheritanceModelContract
  extend ActiveSupport::Concern

  included do
    attribute model.inheritance_column

    validate do
      if model.type != model.class.sti_name
        errors.add :type, :error_readonly # as in users should not be passing this
      end
    end
  end
end
