#-- encoding: UTF-8



require 'spec_helper'

describe SCM::CreateLocalRepositoryJob do
  let(:instance) { described_class.new }
  subject { instance.perform(repository) }

  # Allow to override configuration values to determine
  # whether to activate managed repositories
  let(:enabled_scms) { %w[subversion git] }
  let(:config) { nil }

  before do
    allow(Setting).to receive(:enabled_scm).and_return(enabled_scms)

    allow(OpenProject::Configuration).to receive(:[]).and_call_original
    allow(OpenProject::Configuration).to receive(:[]).with('scm').and_return(config)
  end

  describe 'with a managed repository' do
    include_context 'with tmpdir'

    let(:project) { FactoryBot.build(:project) }
    let(:repository) do
      repo = Repository::Subversion.new(scm_type: :managed)
      repo.project = project
      repo.configure(:managed, nil)
      repo
    end

    let(:config) do
      { subversion: { mode: mode, manages: tmpdir } }
    end

    shared_examples 'creates a directory with mode' do |expected|
      it 'creates the directory' do
        subject
        expect(Dir.exists?(repository.root_url)).to be true

        file_mode = File.stat(repository.root_url).mode
        expect(sprintf("%o", file_mode)).to end_with(expected)
      end
    end

    context 'with mode set' do
      let(:mode) { 0o770 }

      it 'uses the correct mode' do
        expect(instance).to receive(:create).with(mode)
        subject
      end

      it_behaves_like 'creates a directory with mode', '0770'
    end

    context 'with string mode' do
      let(:mode) { '0770' }
      it 'uses the correct mode' do
        expect(instance).to receive(:create).with(0o770)
        subject
      end

      it_behaves_like 'creates a directory with mode', '0770'
    end

    context 'with no mode set' do
      let(:mode) { nil }
      it 'uses the default mode' do
        expect(instance).to receive(:create).with(0o700)
        subject
      end

      it_behaves_like 'creates a directory with mode', '0700'
    end
  end
end
