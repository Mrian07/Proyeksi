#-- encoding: UTF-8


module Bim
  module DemoData
    class IfcModelSeeder < ::Seeder
      attr_reader :project, :key

      def initialize(project, key)
        @project = project
        @key = key
      end

      def seed_data!
        models = project_data_for(key, 'ifc_models')
        return unless models.present?

        print_status '    ↳ Import IFC Models'

        models.each do |model|
          seed_model model
        end
      end

      private

      def seed_model(model)
        user = User.admin.first

        xkt_data = get_file model[:file], '.xkt'

        if xkt_data.nil?
          print_status "\n    ↳ Missing converted data for ifc model"
        else
          create_model(model, user, xkt_data)
        end
      end

      def create_model(model, user, xkt_data)
        model_container = create_model_container project, user, model[:name], model[:default]

        add_ifc_model_attachment model_container, user, xkt_data, 'xkt'
      end

      def create_model_container(project, user, title, default)
        model_container = Bim::IfcModels::IfcModel.new
        model_container.title = title
        model_container.project = project
        model_container.uploader = user
        model_container.is_default = default

        model_container.save!
        model_container
      end

      def add_ifc_model_attachment(model_container, user, file, description)
        attachment = Attachment.new(
          container: model_container,
          author: user,
          file: file,
          description: description
        )
        attachment.save!
      end

      def get_file(name, ending)
        path = 'modules/bim/files/ifc_models/' + name + '/'
        file_name = name + ending
        return unless File.exist?(path + file_name)

        File.new(File.join(Rails.root,
                           path,
                           file_name))
      end
    end
  end
end
