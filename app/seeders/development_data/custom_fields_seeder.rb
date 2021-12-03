module DevelopmentData
  class CustomFieldsSeeder < Seeder
    def seed_data!
      CustomField.transaction do
        print_status '    ↳ Creating custom fields...'
        cfs = create_cfs!

        print_status "\n    ↳ Creating types for linking CFs"
        create_types!(cfs)
      end

      puts
    end

    def all_cfs
      %w(string text date list multilist int intrange float user version)
    end

    def create_types!(cfs)
      # Create ALL CFs types
      non_req_cfs = cfs.reject(&:is_required).map { |cf| "custom_field_#{cf.id}" }
      type = FactoryBot.build :type, name: 'All CFS'
      extend_group(type, ['Custom fields', non_req_cfs])
      type.save!
      print_status '.'

      # Create type
      req_cfs = cfs.select(&:is_required).map { |cf| "custom_field_#{cf.id}" }
      type_req = FactoryBot.build :type, name: 'Required CF'
      extend_group(type_req, ['Custom fields', req_cfs])
      type_req.save!
      print_status '.'
    end

    def create_cfs!
      cfs = []

      # create some custom fields and add them to the project
      (all_cfs - %w(list multilist intrange)).each do |type|
        cfs << CustomField.create!(name: "CF DEV #{type}",
                                   type: 'WorkPackageCustomField',
                                   is_required: false,
                                   field_format: type)
        print_status '.'
      end

      cfs << CustomField.create!(name: "CF DEV list",
                                 is_required: false,
                                 type: 'WorkPackageCustomField',
                                 possible_values: ['A', 'B', 'C'],
                                 field_format: 'list')
      print_status '.'

      cfs << CustomField.create!(name: "CF DEV multilist",
                                 type: 'WorkPackageCustomField',
                                 is_required: false,
                                 multi_value: true,
                                 possible_values: ['Foo', 'Bar', 'Bla'],
                                 field_format: 'list')
      print_status '.'

      cfs << CustomField.create!(name: "CF DEV required text",
                                 type: 'WorkPackageCustomField',
                                 is_required: true,
                                 field_format: 'text')
      print_status '.'

      cfs << CustomField.create!(name: "CF DEV intrange",
                                 type: 'WorkPackageCustomField',
                                 min_length: 2,
                                 max_length: 5,
                                 field_format: 'int')
      print_status '.'

      cfs
    rescue StandardError => e
      binding.pry
    end

    def extend_group(type, group)
      groups = type.send(:custom_attribute_groups) || type.default_attribute_groups
      groups << group
      type.attribute_groups = groups
    end

    def applicable?
      CustomField.where("name LIKE 'CF DEV%'").count == 0
    end
  end
end
