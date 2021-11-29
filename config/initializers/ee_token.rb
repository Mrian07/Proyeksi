begin
  data = File.read(Rails.root.join(".proyeksi-token.pub"))
  key = OpenSSL::PKey::RSA.new(data)
  OpenProject::Token.key = key
rescue StandardError
  warn "WARNING: Missing .proyeksi-token.pub key"
end
