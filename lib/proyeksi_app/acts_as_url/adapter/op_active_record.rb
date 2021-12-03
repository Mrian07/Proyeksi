#-- encoding: UTF-8



# Improves handling of some edge cases when to_url is called. The method is provided by
# stringex but some edge cases have not been handled properly by that gem.
#
# This includes
#   * the strings '.' and '!' which would lead to an empty string otherwise

module ProyeksiApp
  module ActsAsUrl
    module Adapter
      class OpActiveRecord < Stringex::ActsAsUrl::Adapter::ActiveRecord

        ##
        # Avoid generating the slug if the attribute is already set
        # and only_when_blank is true
        def ensure_unique_url!(instance)
          attribute = instance.send(settings.url_attribute)
          super if attribute.blank? || !settings.only_when_blank
        end

        ##
        # Always return the stored url, even if it has errors
        def url_attribute(instance)
          read_attribute instance, settings.url_attribute
        end

        private

        def modify_base_url
          root = instance.send(settings.attribute_to_urlify).to_s
          locale = configuration.settings.locale || :en
          self.base_url = root.to_localized_slug(locale: locale, **configuration.string_extensions_settings)

          modify_base_url_custom_rules if base_url.empty?
        end

        def modify_base_url_custom_rules
          replacement = case instance.send(settings.attribute_to_urlify).to_s
                        when '.'
                          'dot'
                        when '!'
                          'bang'
                        end

          self.base_url = replacement if replacement
        end
      end
    end
  end
end
