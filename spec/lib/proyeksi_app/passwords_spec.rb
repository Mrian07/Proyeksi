

require 'spec_helper'
require 'proyeksi_app/passwords'

describe ProyeksiApp::Passwords::Generator do
  describe '#random_password',
           with_settings: {
             password_active_rules: %w(lowercase uppercase numeric special),
             password_min_adhered_rules: 3,
             password_min_length: 4
           } do
    it 'should create a valid password' do
      pwd = ProyeksiApp::Passwords::Generator.random_password
      expect(ProyeksiApp::Passwords::Evaluator.conforming?(pwd)).to eq(true)
    end
  end
end

describe ProyeksiApp::Passwords::Evaluator,
         with_settings: {
           password_active_rules: %w(lowercase uppercase numeric),
           password_min_adhered_rules: 3,
           password_min_length: 4
         } do
  it 'should correctly evaluate passwords' do
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('abCD')).to eq(false)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('ab12')).to eq(false)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('12CD')).to eq(false)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('12CD*')).to eq(false)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('aB1')).to eq(false)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('abCD12')).to eq(true)
    expect(ProyeksiApp::Passwords::Evaluator.conforming?('aB123')).to eq(true)
  end
end
