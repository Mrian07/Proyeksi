

# Disposable from 0.6.0 on includes Forwardable into every
# class inheriting from Disposable::Twin. OpenProject
# uses Disposable::Twin for the contracts.
# Including Forwardable overwrites the rails core_ext delegate
# on which e.g. ActiveModel::Naming relies.
OpenProject::Patches.patch_gem_version 'disposable', '6.0.1' do
  # The patch thus loads the module including Forwardable, then removes the
  # code and defines its own empty module.
  module Disposable
    class Twin
      module Property

      end
    end
  end

  require "disposable/twin/property/unnest"
  Disposable::Twin::Property.send(:remove_const, :Unnest)

  module Disposable
    class Twin
      module Property
        module Unnest
          def unnest(_name, _options)
            raise 'Relying on patched away method'
          end
        end
      end
    end
  end

  require 'disposable'
end
