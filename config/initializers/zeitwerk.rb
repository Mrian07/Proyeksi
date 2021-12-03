require Rails.root.join('config/constants/proyeksi_app/inflector')

ProyeksiApp::Inflector.rule do |_, abspath|
  if abspath.match?(/proyeksi_app\/version(\.rb)?\z/) ||
     abspath.match?(/lib\/proyeksi_app\/\w+\/version(\.rb)?\z/)
    "VERSION"
  end
end

ProyeksiApp::Inflector.rule do |basename, abspath|
  case basename
  when /\Aapi_(.*)\z/
    'API' + default_inflect($1, abspath)
  when /\A(.*)_api\z/
    default_inflect($1, abspath) + 'API'
  when 'api'
    'API'
  end
end

ProyeksiApp::Inflector.rule do |basename, abspath|
  if basename =~ /\Aar_(.*)\z/
    'AR' + default_inflect($1, abspath)
  end
end

ProyeksiApp::Inflector.rule do |basename, abspath|
  case basename
  when /\Aoauth_(.*)\z/
    'OAuth' + default_inflect($1, abspath)
  when /\A(.*)_oauth\z/
    default_inflect($1, abspath) + 'OAuth'
  when 'oauth'
    'OAuth'
  end
end

ProyeksiApp::Inflector.rule do |basename, abspath|
  if basename =~ /\A(.*)_sso\z/
    default_inflect($1, abspath) + 'SSO'
  end
end

# Instruct zeitwerk to 'ignore' all the engine gems' lib initialization files.
# As it is complicated to return all the paths where such an initialization file might exist,
# we simply return the general ProyeksiApp namespace for such files.
ProyeksiApp::Inflector.rule do |_basename, abspath|
  if abspath =~ /\/lib\/proyeksiapp-\w+.rb\z/
    'ProyeksiApp'
  end
end

ProyeksiApp::Inflector.inflection(
  'rss' => 'RSS',
  'sha1' => 'SHA1',
  'sso' => 'SSO',
  'csv' => 'CSV',
  'pdf' => 'PDF',
  'scm' => 'SCM',
  'imap' => 'IMAP',
  'pop3' => 'POP3',
  'cors' => 'CORS',
  'openid_connect' => 'OpenIDConnect',
  'pdf_export' => 'PDFExport'
)

Rails.autoloaders.each do |autoloader|
  autoloader.inflector = ProyeksiApp::Inflector.new(__FILE__)
end

Rails.autoloaders.main.ignore(Rails.root.join('lib/plugins'))
Rails.autoloaders.main.ignore(Rails.root.join('lib/proyeksi_app/patches'))
Rails.autoloaders.main.ignore(Rails.root.join('lib/generators'))
Rails.autoloaders.main.ignore(Bundler.bundle_path.join('**/*.rb'))

# Comment in to enable zeitwerk logging.
# Rails.autoloaders.main.log!
