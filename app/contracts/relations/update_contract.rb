#-- encoding: UTF-8



require 'relations/base_contract'

module Relations
  class UpdateContract < BaseContract
    validate :from_immutable
    validate :to_immutable

    private

    def from_immutable
      errors.add :from, :error_readonly if from_id_changed_and_not_swapped?
    end

    def to_immutable
      errors.add :to, :error_readonly if to_id_changed_and_not_swapped?
    end

    def from_id_changed_and_not_swapped?
      model.from_id_changed? && !from_and_to_swapped?
    end

    def to_id_changed_and_not_swapped?
      model.to_id_changed? && !from_and_to_swapped?
    end

    def from_and_to_swapped?
      model.to_id == model.from_id_was && model.from_id == model.to_id_was
    end
  end
end
