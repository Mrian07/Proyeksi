#-- encoding: UTF-8



# Adds fallback to default locale for untranslated strings
I18n::Backend::Simple.include I18n::Backend::Fallbacks

# As we enabled +config.i18n.fallbacks+, Rails will fall back
# to the default locale.
# When other locales are available, fall back to them.
if Setting.table_exists? # don't want to prevent migrations
  defaults = Set.new I18n.fallbacks.defaults + Setting.available_languages.map(&:to_sym)
  I18n.fallbacks.defaults = defaults
end
