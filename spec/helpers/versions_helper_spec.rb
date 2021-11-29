

require 'spec_helper'

describe VersionsHelper, type: :helper do
  include ApplicationHelper

  let(:test_project) { FactoryBot.build_stubbed :valid_project }
  let(:version) { FactoryBot.build_stubbed :version, project: test_project }

  describe '#format_version_name' do
    context 'a version' do
      it 'can be formatted' do
        expect(format_version_name(version)).to eq("#{test_project.name} - #{version.name}")
      end

      it 'can be formatted within a project' do
        @project = test_project
        expect(format_version_name(version)).to eq(version.name)
      end
    end

    context 'a system version' do
      let(:version) { FactoryBot.build_stubbed :version, project: test_project, sharing: 'system' }

      it 'can be formatted' do
        expect(format_version_name(version)).to eq("#{test_project.name} - #{version.name}")
      end
    end
  end

  describe '#link_to_version' do
    context 'a version' do
      context 'with being allowed to see the version' do
        it 'does not create a link, without permission' do
          expect(link_to_version(version))
            .to eq("#{test_project.name} - #{version.name}")
        end
      end

      describe 'with a user being allowed to see the version' do
        before do
          allow(version)
            .to receive(:visible?)
            .and_return(true)
        end

        it 'generates a link' do
          expect(link_to_version(version))
            .to be_html_eql("<a href=\"/versions/#{version.id}\" id=\"version-#{ERB::Util.url_encode(version.name)}\">#{test_project.name} - #{version.name}</a>")
        end

        it 'generates a link within a project' do
          @project = test_project
          expect(link_to_version(version))
            .to be_html_eql("<a href=\"/versions/#{version.id}\" id=\"version-#{ERB::Util.url_encode(version.name)}\">#{version.name}</a>")
        end
      end
    end

    describe '#link_to_version_id' do
      it 'generates an escaped id' do
        expect(link_to_version_id(version))
          .to eql("version-#{ERB::Util.url_encode(version.name)}")
      end
    end
  end

  describe '#version_options_for_select' do
    it 'generates nothing without a version' do
      expect(version_options_for_select([])).to be_empty
    end

    it 'generates an option tag' do
      expect(version_options_for_select([],
                                        version)).to eq("<option selected=\"selected\" value=\"#{version.id}\">#{version.name}</option>")
    end
  end
end
