#-- encoding: UTF-8



module OpenProject
  module AccessControl
    class << self
      include ::Redmine::I18n

      def map
        mapper = OpenProject::AccessControl::Mapper.new
        yield mapper
        @permissions ||= []
        @permissions += mapper.mapped_permissions
        @modules ||= []
        @modules += mapper.mapped_modules
        @project_modules_without_permissions ||= []
        @project_modules_without_permissions += mapper.project_modules_without_permissions
      end

      # Get a sorted array of module names
      #
      # @param include_disabled [boolean] Whether to return all modules or only those that are active (not disabled by config)
      def sorted_module_names(include_disabled = true)
        modules
          .reject { |mod| !include_disabled && disabled_project_modules.include?(mod[:name]) }
          .sort_by { |a| [-a[:order], l_or_humanize(a[:name], prefix: 'project_module_')] }
          .map { |entry| entry[:name].to_s }
      end

      def permissions
        @permissions.select(&:enabled?)
      end

      def modules
        @modules.uniq { |mod| mod[:name] }
      end

      # Returns the permission of given name or nil if it wasn't found
      # Argument should be a symbol
      def permission(name)
        permissions.detect { |p| p.name == name }
      end

      # Returns the actions that are allowed by the permission of given name
      def allowed_actions(permission_name)
        perm = permission(permission_name)
        perm ? perm.controller_actions : []
      end

      def allow_actions(action_hash)
        action = "#{action_hash[:controller]}/#{action_hash[:action]}"

        permissions.select { |p| p.controller_actions.include? action }
      end

      def public_permissions
        @public_permissions ||= @permissions.select(&:public?)
      end

      def members_only_permissions
        @members_only_permissions ||= @permissions.select(&:require_member?)
      end

      def loggedin_only_permissions
        @loggedin_only_permissions ||= @permissions.select(&:require_loggedin?)
      end

      def global_permissions
        @permissions.select(&:global?)
      end

      def available_project_modules
        @available_project_modules ||= begin
          (@permissions.reject(&:global?).map(&:project_module) + @project_modules_without_permissions)
            .uniq
            .compact
            .reject { |name| disabled_project_modules.include? name }
        end
      end

      def disabled_project_modules
        @disabled_project_modules ||= modules
          .select { |entry| entry[:if].respond_to?(:call) && !entry[:if].call }
          .map { |entry| entry[:name].to_sym }
      end

      def modules_permissions(modules)
        @permissions.select { |p| p.project_module.nil? || modules.include?(p.project_module.to_s) }
      end

      def contract_actions_map
        @contract_actions_map ||= permissions.each_with_object({}) do |p, hash|
          next unless p.contract_actions.any?

          hash[p.name] = { actions: p.contract_actions, global: p.global?, module: p.project_module }
        end
      end

      def remove_modules_permissions(module_name)
        permissions = @permissions

        module_permissions = permissions.select { |p| p.project_module.to_s == module_name.to_s }

        clear_caches

        @permissions = permissions - module_permissions
      end

      def clear_caches
        @available_project_modules = nil
        @public_permissions = nil
        @members_only_permissions = nil
        @loggedin_only_permissions = nil
        @contract_actions_map = nil
      end
    end
  end
end
