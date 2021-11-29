

# explicitly require what will be patched to be loaded from the ReportingEngine
require_dependency 'widget/settings'

module Widget::SettingsPatch
  extend ActiveSupport::Concern

  included do
    prepend InstanceMethods
  end

  module InstanceMethods
    def settings_to_render
      super.insert(-2, :cost_types)
    end

    def render_cost_types_settings
      render_widget Widget::Settings::Fieldset, @subject, type: "units" do
        render_widget Widget::CostTypes,
                      @cost_types,
                      selected_type_id: @selected_type_id
      end
    end

    def render_with_options(options, &block)
      @cost_types = options.delete(:cost_types)
      @selected_type_id = options.delete(:selected_type_id)

      super(options, &block)
    end
  end
end

Widget::Settings.include Widget::SettingsPatch
