

require 'spec_helper'

require_relative '../../../support/bcf_topic_with_stubbed_comment'

describe ::API::V3::WorkPackages::WorkPackageRepresenter do
  include API::V3::Utilities::PathHelper
  include API::Bim::Utilities::PathHelper

  let(:project) do
    work_package.project
  end
  include_context 'user with stubbed permissions'
  include_context 'bcf_topic with stubbed comment'
  let(:permissions) { %i[view_linked_issues view_work_packages manage_bcf] }
  let(:work_package) do
    FactoryBot.build_stubbed(:stubbed_work_package, bcf_issue: bcf_topic)
  end
  let(:representer) do
    described_class.new(work_package,
                        current_user: user,
                        embed_links: true)
  end

  before(:each) do
    login_as user
  end

  subject(:generated) { representer.to_json }

  include_context 'eager loaded work package representer'

  describe '_links' do
    describe 'bcfTopic' do
      context 'if a topic is present' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'bcfTopic' }
          let(:href) { "/api/bcf/2.1/projects/#{project.identifier}/topics/#{bcf_topic.uuid}" }
        end
      end

      context 'if no topic is present' do
        let(:bcf_topic) { nil }

        it_behaves_like 'has no link' do
          let(:link) { 'bcfTopic' }
        end
      end

      context 'if permission is lacking' do
        let(:permissions) { %i[view_work_packages] }

        it_behaves_like 'has no link' do
          let(:link) { 'bcfTopic' }
        end
      end
    end

    describe 'bcfViewpoints' do
      context 'if a viewpoint is present' do
        it_behaves_like 'has a link collection' do
          let(:link) { 'bcfViewpoints' }
          let(:hrefs) do
            [
              {
                href: bcf_v2_1_paths.viewpoint(project.identifier, bcf_topic.uuid, bcf_topic.viewpoints[0].uuid)
              }
            ]
          end
        end

        context 'if no topic is present' do
          let(:bcf_topic) { nil }

          it_behaves_like 'has no link' do
            let(:link) { 'bcfViewpoints' }
          end
        end

        context 'if no viewpoint is present' do
          before do
            allow(bcf_topic)
              .to receive(:viewpoints)
              .and_return []
          end

          it_behaves_like 'has a link collection' do
            let(:link) { 'bcfViewpoints' }
            let(:hrefs) do
              []
            end
          end
        end

        context 'if permission is lacking' do
          let(:permissions) { %i[view_work_packages] }

          it_behaves_like 'has no link' do
            let(:link) { 'bcfViewpoints' }
          end
        end
      end
    end

    describe 'convertBCF' do
      let(:link) { 'convertBCF' }

      context 'if no bcf issue is assigned yet' do
        let(:bcf_topic) { nil }

        it_behaves_like 'has a titled link' do
          let(:title) { 'Convert to BCF' }
          let(:href) { "/api/bcf/2.1/projects/#{project.identifier}/topics" }
        end

        it 'signalizes the payload' do
          is_expected
            .to be_json_eql({ "reference_links": ["/api/v3/work_packages/#{work_package.id}"] }.to_json)
            .at_path('_links/convertBCF/payload')
        end
      end

      context 'if a bcf issue is assigned' do
        it_behaves_like 'has no link'
      end

      context 'if no bcf issue iss assigned but the user lacks permission' do
        let(:bcf_topic) { nil }
        let(:permissions) { %i[view_linked_issues view_work_packages] }

        it_behaves_like 'has no link'
      end
    end
  end
end
