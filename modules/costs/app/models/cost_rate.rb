

class CostRate < Rate
  belongs_to :cost_type

  validates_uniqueness_of :valid_from, scope: :cost_type_id
  validate :change_of_cost_type_only_on_first_creation

  def previous(reference_date = valid_from)
    # This might return a default rate
    cost_type.rate_at(reference_date - 1)
  end

  def next(reference_date = valid_from)
    CostRate
      .where(['cost_type_id = ? and valid_from > ?', cost_type_id, reference_date])
      .order(Arel.sql('valid_from ASC'))
      .first
  end

  private

  def change_of_cost_type_only_on_first_creation
    errors.add :cost_type_id, :invalid if cost_type_id_changed? && !new_record?
  end
end
