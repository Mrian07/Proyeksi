#-- encoding: UTF-8



desc 'Generates a secret token file.'

file 'config/secret_token.yml' do
  path = Rails.root.join('config/secret_token.yml').to_s
  secret = SecureRandom.hex(64)
  File.open(path, 'w') do |f|
    f.write <<~"EOF"
      secret_token: '#{secret}'
    EOF
  end
end

desc 'Generates a secret token file.'
task generate_secret_token: ['config/secret_token.yml']
