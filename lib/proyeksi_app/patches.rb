# encoding: utf-8



module ProyeksiApp
  module Patches
    module_function

    ##
    # Check against a particular gem version
    # before patching it
    def patch_gem_version(gem, version, &block)
      found_version = Gem.loaded_specs[gem].version
      if found_version > Gem::Version.new(version)
        raise "ProyeksiApp expects to patch gem '#{gem}' at version #{version} " \
              "but found version #{found_version.to_s}. Please check whether the patch is still valid."
      end

      block.call
    end
  end
end
