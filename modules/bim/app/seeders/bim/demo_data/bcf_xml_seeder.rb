#-- encoding: UTF-8


module Bim
  module DemoData
    class BcfXmlSeeder < ::Seeder
      attr_reader :project, :key

      def initialize(project, key)
        @project = project
        @key = key
      end

      def seed_data!
        filename = project_data_for(key, 'bcf_xml_file')
        return unless filename.present?

        user = User.admin.active.first

        print_status '    ↳ Import BCF XML file'

        import_options = {
          invalid_people_action: 'anonymize',
          unknown_mails_action: 'anonymize',
          non_members_action: 'anonymize'
        }

        bcf_xml_file = File.new(File.join(Rails.root, 'modules/bim/files', filename))
        importer = ::ProyeksiApp::Bim::BcfXml::Importer.new(bcf_xml_file, project, current_user: user)
        importer.import!(import_options).flatten
      end
    end
  end
end
