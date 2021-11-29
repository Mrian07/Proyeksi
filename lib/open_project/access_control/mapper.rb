#-- encoding: UTF-8



module OpenProject
  module AccessControl
    class Mapper
      def permission(name, hash, options = {})
        options[:project_module] = @project_module
        mapped_permissions << Permission.new(name, hash, options)
      end

      def project_module(name, options = {})
        options[:dependencies] = Array(options[:dependencies]) if options[:dependencies]
        mapped_modules << { name: name, order: 0 }.merge(options)

        if block_given?
          @project_module = name
          yield self
          @project_module = nil
        else
          project_modules_without_permissions << name
        end
      end

      def mapped_modules
        @mapped_modules ||= []
      end

      def mapped_permissions
        @permissions ||= []
      end

      def project_modules_without_permissions
        @project_modules_without_permissions ||= []
      end
    end
  end
end
