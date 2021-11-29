

module Costs::Patches::NumberToCurrencyConverterPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def i18n_opts
      super.merge(unit: ERB::Util.h(Setting.plugin_costs['costs_currency']),
                  format: ERB::Util.h(Setting.plugin_costs['costs_currency_format']))
    end
  end
end
