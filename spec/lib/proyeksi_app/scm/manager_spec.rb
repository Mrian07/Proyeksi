#-- encoding: UTF-8



require 'spec_helper'

describe ProyeksiApp::SCM::Manager do
  let(:vendor) { 'TestScm' }
  let(:scm_class) { Class.new }

  before do
    Repository.const_set(vendor, scm_class)
    ProyeksiApp::SCM::Manager.add :test_scm
  end

  after do
    Repository.send(:remove_const, vendor)
    ProyeksiApp::SCM::Manager.delete :test_scm
  end

  it 'is a valid const' do
    expect(ProyeksiApp::SCM::Manager.registered[:test_scm]).to eq(Repository::TestScm)
  end

  context 'scm is not known' do
    it 'is not included' do
      expect(ProyeksiApp::SCM::Manager.registered).to_not have_key(:some_scm)
    end
  end
end
