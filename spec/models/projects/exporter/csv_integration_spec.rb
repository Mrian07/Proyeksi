#-- encoding: UTF-8



require 'spec_helper'
require_relative 'exportable_project_context'

describe Projects::Exports::CSV, 'integration', type: :model do
  include_context 'with a project with an arrangement of custom fields'
  include_context 'with an instance of the described exporter'

  let(:parsed) do
    CSV.parse(output)
  end

  let(:header) { parsed.first }

  let(:rows) { parsed.drop(1) }

  it 'performs a successful export' do
    expect(parsed.size).to eq(2)
    expect(parsed.last).to eq [project.id.to_s, project.identifier, project.name, 'Off track', 'false']
  end

  describe 'custom field columns selected' do
    before do
      Setting.enabled_projects_columns += custom_fields.map { |cf| "cf_#{cf.id}" }
    end

    context 'when ee enabled', with_ee: %i[custom_fields_in_projects_list] do
      it 'renders all those columns' do
        expect(parsed.size).to eq 2

        cf_names = custom_fields.map(&:name)
        expect(header).to eq ['id', 'Identifier', 'Name', 'Status', 'Public', *cf_names]

        custom_values = custom_fields.map do |cf|
          if cf == bool_cf
            'true'
          else
            project.formatted_custom_value_for(cf)
          end
        end
        expect(rows.first)
          .to eq [project.id.to_s, project.identifier, project.name, 'Off track', 'false', *custom_values]
      end
    end

    context 'when ee not enabled' do
      it 'renders only the default columns' do
        expect(header).to eq %w[id Identifier Name Status Public]
      end
    end
  end

  context 'with no project visible' do
    let(:current_user) { User.anonymous }

    it 'does not include the project' do
      expect(output).not_to include project.identifier
      expect(parsed.size).to eq(1)
    end
  end
end
