#-- encoding: UTF-8

module BasicData
  class TypeSeeder < Seeder
    def seed_data!
      Type.transaction do
        data.each do |attributes|
          Type.create!(attributes)
        end
      end
    end

    def applicable
      Type.all.any?
    end

    def not_applicable_message
      'Skipping types - already exists/configured'
    end

    ##
    # Returns the data of all types to seed.
    #
    # @return [Array<Hash>] List of attributes for each type.
    def data
      colors = Color.all
      colors = colors.map { |c| { c.name => c.id } }.reduce({}, :merge)

      type_table.map do |_name, values|
        color_id = colors[values[2]] || values[2]

        {
          name: I18n.t(values[5]),
          position: values[0],
          is_default: values[1],
          color_id: color_id,
          is_in_roadmap: values[3],
          is_milestone: values[4],
          description: type_description(values[5])
        }
      end
    end

    def type_names
      raise NotImplementedError
    end

    def type_table
      raise NotImplementedError
    end

    def type_description(type_name)
      return '' if demo_data_for('type_configuration').nil?

      demo_data_for('type_configuration').each do |entry|
        if entry[:type] && I18n.t(entry[:type]) === I18n.t(type_name)
          return entry[:description] || ''
        else
          return ''
        end
      end
    end

    def set_attribute_groups_for_type(type)
      return if demo_data_for('type_configuration').nil?

      demo_data_for('type_configuration').each do |entry|
        if entry[:form_configuration] && I18n.t(entry[:type]) === type.name

          entry[:form_configuration].each do |form_config_attr|
            groups = type.default_attribute_groups
            query_association = 'query_' + find_query_by_name(form_config_attr[:query_name]).to_s
            groups.unshift([form_config_attr[:group_name], [query_association.to_sym]])

            type.attribute_groups = groups
          end

          type.save!
        end
      end
    end

    private

    def find_query_by_name(name)
      Query.find_by(name: name).id
    end
  end
end
