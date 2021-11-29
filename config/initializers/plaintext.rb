

file_name = File.join([Rails.root.to_s, 'config', 'plaintext.yml'])
if File.file?(file_name)
  config_file = File.read(file_name)
  Plaintext::Configuration.load(config_file)
end
