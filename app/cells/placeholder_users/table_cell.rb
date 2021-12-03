module PlaceholderUsers
  class TableCell < ::TableCell
    options :current_user # adds this option to those of the base class
    columns :name, :created_at

    def initial_sort
      %i[id asc]
    end

    def headers
      columns.map do |name|
        [name.to_s, header_options(name)]
      end
    end

    def header_options(name)
      options = { caption: PlaceholderUser.human_attribute_name(name) }

      options[:default_order] = 'desc' if desc_by_default.include? name

      options
    end

    def desc_by_default
      [:created_at]
    end

    def user_allowed_service
      @user_allowed_service ||= Authorization::UserAllowedService.new(options[:current_user])
    end
  end
end
