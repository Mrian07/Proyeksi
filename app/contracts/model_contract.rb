require_relative './base_contract'

##
# Model contract for AR records that
# support change tracking
class ModelContract < BaseContract
  def valid?(*_args)
    super()
    readonly_attributes_unchanged

    # Allow subclasses to check only contract errors
    return errors.empty? unless validate_model?

    model.valid?

    # We need to merge the contract errors with the model errors in
    # order to have them available at one place.
    # This is something we need as long as we have validations split
    # among the model and its contract.
    errors.merge!(model.errors)

    errors.empty?
  end

  protected

  ##
  # Allow subclasses to disable model validation
  # during contract validation.
  #
  # This is necessary during, e.g., deletion contract validations
  # to ensure invalid models can be deleted when allowed.
  def validate_model?
    true
  end

  private

  def readonly_attributes_unchanged
    unauthenticated_changed.each do |attribute|
      outside_attribute = collect_ancestor_attribute_aliases[attribute] || attribute

      errors.add outside_attribute, :error_readonly
    end
  end

  def unauthenticated_changed
    changed_by_user - writable_attributes
  end

  def changed_by_user
    model.respond_to?(:changed_by_user) ? model.changed_by_user : model.changed
  end
end
