

module ProyeksiApp
  module Patches
    ##
    # Crowdin currently breaks some of our pluralized strings
    # in locales other than the english source.
    #
    # Strings are being downloaded with an empty string as value despite
    # showing up correctly in their UI.
    #
    # This results in the fallback not properly working as it's not checking
    # for empty strings.
    #
    # This patch removes empty string values from the loaded YML before they
    # are being processed by fallbacks. With it, english fallbacks can be used automatically.
    # https://community.proyeksiapp.com/wp/36304
    module I18nRejectEmptyString
      def load_yml(filename)
        replace_empty_strings super
      end

      def replace_empty_strings(hash)
        hash.deep_transform_values do |value|
          if value == ''
            nil
          else
            value
          end
        end
      end
    end
  end
end

ProyeksiApp::Patches.patch_gem_version 'i18n', '1.8.11' do
  I18n.backend.singleton_class.prepend ProyeksiApp::Patches::I18nRejectEmptyString
end
