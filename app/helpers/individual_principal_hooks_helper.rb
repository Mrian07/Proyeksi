#-- encoding: UTF-8



module IndividualPrincipalHooksHelper
  def call_individual_principals_memberships_hook(individual_principal, suffix, context = {})
    call_context = { individual_principal_key(individual_principal) => individual_principal }.merge(context)
    call_hook("view_#{individual_principal.class.name.underscore.pluralize}_memberships_table_#{suffix}".to_sym, call_context)
  end

  def individual_principal_key(individual_principal)
    individual_principal.class.name.underscore.to_sym
  end
end
