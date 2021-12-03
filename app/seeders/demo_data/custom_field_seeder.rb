module DemoData
  class CustomFieldSeeder < Seeder
    attr_reader :project, :key

    def initialize(project, key)
      @project = project
      @key = key
    end

    def seed_data!
      # Careful: The seeding recreates the seeded project before it runs, so any changes
      # on the seeded project will be lost.
      print_status '    ↳ Creating custom fields...' do
        # create some custom fields and add them to the project
        Array(project_data_for(key, 'custom_fields')).each do |name|
          cf = WorkPackageCustomField.create!(
            name: name,
            regexp: '',
            is_required: false,
            min_length: false,
            default_value: '',
            max_length: false,
            editable: true,
            possible_values: '',
            visible: true,
            field_format: 'text'
          )
          print_status '.'

          project.work_package_custom_fields << cf
        end
      end
    end

    def applicable?
      not WorkPackageCustomField.any?
    end
  end
end
