begin
  data = File.read(Rails.root.join(".proyeksiapp-token.pub"))
  key = OpenSSL::PKey::RSA.new(data)
  ProyeksiApp::Token.key = key
rescue StandardError
  warn "WARNING: Missing .proyeksiapp-token.pub key"
end
