

module ProyeksiApp::Patches::DeclarativeOption
  extend ActiveSupport::Concern

  included do
    private

    # Override Declarative::Option to avoid ruby 2.7.1 warnings about using the last argument as keyword parameter.
    def lambda_for_proc(value, options)
      return ->(context, **args) { context.instance_exec(**args, &value) } if options[:instance_exec]

      value
    end
  end
end

ProyeksiApp::Patches.patch_gem_version 'declarative-option', '0.1.0' do
  unless Declarative::Option.included_modules.include?(ProyeksiApp::Patches::DeclarativeOption)
    Declarative::Option.include ProyeksiApp::Patches::DeclarativeOption
  end
end
