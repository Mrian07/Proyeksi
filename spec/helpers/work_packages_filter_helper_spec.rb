

require 'spec_helper'

describe WorkPackagesFilterHelper, type: :helper do
  let(:project) { FactoryBot.create(:project) }
  let(:version) { FactoryBot.create(:version, project: project) }
  let(:global) { false }

  shared_examples_for 'work package path with query_props' do
    it 'is the expected path' do
      path_regexp = if global
                      Regexp.new("^#{work_packages_path}\\?query_props=(.*)")
                    else
                      Regexp.new("^#{project_work_packages_path(project.identifier)}\\?query_props=(.*)")
                    end

      expect(path)
        .to match path_regexp

      query_props = CGI::unescape(path.match(path_regexp)[1])

      expect(JSON.parse(query_props))
        .to eql(expected_json.with_indifferent_access)
    end
  end

  describe '#project_work_packages_closed_version_path' do
    it_behaves_like 'work package path with query_props' do
      let(:expected_json) do
        {
          f: [
            {
              n: 'status',
              o: 'c'
            },
            {
              n: 'version',
              o: '=',
              v: version.id.to_s
            }
          ]
        }
      end

      let(:path) { helper.project_work_packages_closed_version_path(version) }
    end
  end

  describe '#project_work_packages_open_version_path' do
    it_behaves_like 'work package path with query_props' do
      let(:expected_json) do
        {
          f: [
            {
              n: 'status',
              o: 'o'
            },
            {
              n: 'version',
              o: '=',
              v: version.id.to_s
            }
          ]
        }
      end

      let(:path) { helper.project_work_packages_open_version_path(version) }
    end
  end

  context 'project reports path helpers' do
    let(:property_name) { 'priority' }
    let(:property_id) { 5 }

    describe '#project_report_property_path' do
      it_behaves_like 'work package path with query_props' do
        let(:expected_json) do
          {
            f: [
              {
                n: 'status',
                o: '*'
              },
              {
                n: 'subprojectId',
                o: '!*'
              },
              {
                n: property_name,
                o: '=',
                v: property_id.to_s
              }
            ],
            t: 'updated_at:desc'
          }
        end

        let(:path) { helper.project_report_property_path(project, property_name, property_id) }
      end
    end

    describe '#project_report_property_status_path' do
      it_behaves_like 'work package path with query_props' do
        let(:status_id) { 2 }
        let(:expected_json) do
          {
            f: [
              {
                n: 'status',
                o: '=',
                v: status_id.to_s
              },
              {
                n: 'subprojectId',
                o: '!*'
              },
              {
                n: property_name,
                o: '=',
                v: property_id.to_s
              }
            ],
            t: 'updated_at:desc'
          }
        end

        let(:path) { helper.project_report_property_status_path(project, status_id, property_name, property_id) }
      end
    end

    describe '#project_report_property_open_path' do
      it_behaves_like 'work package path with query_props' do
        let(:expected_json) do
          {
            f: [
              {
                n: 'status',
                o: 'o'
              },
              {
                n: 'subprojectId',
                o: '!*'
              },
              {
                n: property_name,
                o: '=',
                v: property_id.to_s
              }
            ],
            t: 'updated_at:desc'
          }
        end

        let(:path) { helper.project_report_property_open_path(project, property_name, property_id) }
      end
    end

    describe '#project_report_property_closed_path' do
      it_behaves_like 'work package path with query_props' do
        let(:expected_json) do
          {
            f: [
              {
                n: 'status',
                o: 'c'
              },
              {
                n: 'subprojectId',
                o: '!*'
              },
              {
                n: property_name,
                o: '=',
                v: property_id.to_s
              }
            ],
            t: 'updated_at:desc'
          }
        end

        let(:path) { helper.project_report_property_closed_path(project, property_name, property_id) }
      end
    end

    describe '#project_version_property_path' do
      it_behaves_like 'work package path with query_props' do
        let(:expected_json) do
          {
            f: [
              {
                n: 'status',
                o: '*'
              },
              {
                n: 'version',
                o: '=',
                v: version.id.to_s
              },
              {
                n: property_name,
                o: '=',
                v: property_id.to_s
              }
            ],
            t: 'updated_at:desc'
          }
        end

        let(:path) { helper.project_version_property_path(version, property_name, property_id) }
      end
    end
  end
end
