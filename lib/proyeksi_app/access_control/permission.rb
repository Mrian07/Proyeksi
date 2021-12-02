#-- encoding: UTF-8



module ProyeksiApp
  module AccessControl
    class Permission
      attr_reader :name,
                  :controller_actions,
                  :contract_actions,
                  :project_module,
                  :dependencies

      def initialize(name, hash, options)
        @name = name
        @controller_actions = []
        @public = options[:public] || false
        @require = options[:require]
        @global = options[:global] || false
        @enabled = options.include?(:enabled) ? options[:enabled] : true
        @dependencies = Array(options[:dependencies]) || []
        @project_module = options[:project_module]
        @contract_actions = options[:contract_actions] || []
        hash.each do |controller, actions|
          @controller_actions << if actions.is_a? Array
                                   actions.map { |action| "#{controller}/#{action}" }
                                 else
                                   "#{controller}/#{actions}"
                                 end
        end
        @controller_actions.flatten!
      end

      def public?
        @public
      end

      def global?
        @global
      end

      def require_member?
        @require && @require == :member
      end

      def require_loggedin?
        @require && (@require == :member || @require == :loggedin)
      end

      def enabled?
        if @enabled.respond_to?(:call)
          @enabled.call
        else
          @enabled
        end
      end
    end
  end
end
