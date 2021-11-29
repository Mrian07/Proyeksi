

require 'spec_helper'

describe SCM::RepositoryFactoryService do
  let(:user) { FactoryBot.build(:user) }
  let(:project) { FactoryBot.build(:project) }

  let(:enabled_scms) { ['subversion', 'git'] }

  let(:params_hash) { {} }
  let(:params) { ActionController::Parameters.new params_hash }

  subject(:service) { SCM::RepositoryFactoryService.new(project, params) }

  before do
    allow(Setting).to receive(:enabled_scm).and_return(enabled_scms)
  end

  context 'with empty hash' do
    it 'should not build a repository' do
      expect { service.build_temporary }
        .to raise_error KeyError
      expect(service.repository).to be_nil
    end
  end

  context 'with valid vendor' do
    let(:params_hash) do
      { scm_vendor: 'subversion' }
    end

    it 'should allow temporary build repository' do
      expect(service.build_temporary).to be true
      expect(service.repository).not_to be_nil
    end

    it 'should not allow to persist a repository' do
      expect { service.build_and_save }
        .to raise_error(ActionController::ParameterMissing)

      expect(service.repository).to be_nil
    end
  end

  context 'with invalid vendor' do
    let(:params_hash) do
      { scm_vendor: 'not_subversion', scm_type: 'foo' }
    end

    it 'should not allow to temporary build repository' do
      expect { service.build_temporary }.not_to raise_error

      expect(service.repository).to be_nil
      expect(service.build_error).to include('The SCM vendor not_subversion is disabled')
    end

    it 'should not allow to persist a repository' do
      expect { service.build_temporary }.not_to raise_error

      expect(service.repository).to be_nil
      expect(service.build_error).to include('The SCM vendor not_subversion is disabled')
    end
  end

  context 'with vendor and type' do
    let(:params_hash) do
      { scm_vendor: 'subversion', scm_type: 'existing' }
    end

    it 'should not allow to persist a repository without URL' do
      expect(service.build_and_save).not_to be true

      expect(service.repository).to be_nil
      expect(service.build_error).to include("URL can't be blank")
    end
  end

  context 'with invalid hash' do
    let(:params_hash) do
      {
        scm_vendor: 'subversion', scm_type: 'existing',
        repository: { url: '/tmp/foo.svn' }
      }
    end

    it 'should not allow to persist a repository URL' do
      expect(service.build_and_save).not_to be true

      expect(service.repository).to be_nil
      expect(service.build_error).to include('URL is invalid')
    end
  end

  context 'with valid hash' do
    let(:params_hash) do
      {
        scm_vendor: 'subversion', scm_type: 'existing',
        repository: { url: 'file:///tmp/foo.svn' }
      }
    end

    it 'should allow to persist a repository without URL' do
      expect(service.build_and_save).to be true
      expect(service.repository).to be_kind_of(Repository::Subversion)
    end
  end
end
