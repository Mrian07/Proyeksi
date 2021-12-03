

module DeprecatedAlias
  def deprecated_alias(old_method, new_method)
    define_method(old_method) do |*args, &block|
      ProyeksiApp::Deprecation.replaced(old_method, new_method, caller)
      send(new_method, *args, &block)
    end
  end
end
