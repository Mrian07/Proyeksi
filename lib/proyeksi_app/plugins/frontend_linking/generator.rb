

require 'bundler'
require 'fileutils'

module ::ProyeksiApp::Plugins
  module FrontendLinking
    class Generator
      attr_reader :proyeksiapp_plugins

      def initialize
        op_dep = load_known_opf_plugins

        @proyeksiapp_plugins = Bundler.load.specs.each_with_object({}) do |spec, h|
          if op_dep.include?(spec.name)
            h[spec.name] = spec.full_gem_path
          end
        end
      end

      ##
      # Register plugins with an Angular frontend to the CLI build.
      # For that, search all gems with the group :opf_plugins
      def regenerate!
        # Create links from plugins angular mdoules to frontend/src
        regenerate_angular_links
      end

      private

      ##
      # Register plugins with an Angular frontend to the CLI build.
      # For that, search all gems with the group :opf_plugins
      def regenerate_angular_links
        all_frontend_plugins.tap do |plugins|
          target_dir = Rails.root.join('frontend', 'src', 'app', 'features', 'plugins', 'linked')
          puts "Cleaning linked target directory #{target_dir}"

          # Removing the current linked directory and recreate
          FileUtils.remove_dir(target_dir, force: true)
          FileUtils.mkdir_p(target_dir)

          plugins.each do |name, path|
            source = File.join(path, 'frontend', 'module')
            target = File.join(target_dir, name)

            puts "Linking frontend of ProyeksiApp plugin #{name} to #{target}."
            FileUtils.ln_sf(source, target)
          end

          generate_plugin_module(all_angular_frontend_plugins)
          generate_plugin_sass(all_plugins_with_global_styles)
        end
      end

      def all_frontend_plugins
        proyeksiapp_plugins.select do |_, path|
          frontend_entry = File.join(path, 'frontend', 'module')
          File.directory? frontend_entry
        end
      end

      def all_angular_frontend_plugins
        proyeksiapp_plugins.select do |_, path|
          frontend_entry = File.join(path, 'frontend', 'module', 'main.ts')
          File.readable? frontend_entry
        end
      end

      def all_plugins_with_global_styles
        proyeksiapp_plugins.select do |_, path|
          style_file = File.join(path, 'frontend', 'module', 'global_styles.*')
          !Dir.glob(style_file).empty?
        end
      end

      ##
      # Regenerate the frontend plugin module orchestrating the linked frontends
      def generate_plugin_module(plugins)
        file_register = Rails.root.join('frontend', 'src', 'app', 'features', 'plugins', 'linked-plugins.module.ts')
        template_file = File.read(File.expand_path('linked-plugins.module.ts.erb', __dir__))
        template = ::ERB.new template_file, trim_mode: '-'

        puts "Regenerating frontend plugin registry #{file_register}."
        context = ::ProyeksiApp::Plugins::FrontendLinking::ErbContext.new plugins
        result = template.result(context.get_binding)
        File.open(file_register, 'w') { |file| file.write(result) }
      end

      ##
      # Regenerate the frontend plugin sass files
      def generate_plugin_sass(plugins)
        file_register = Rails.root.join('frontend', 'src', 'app', 'features', 'plugins', 'linked-plugins.styles.sass')
        template_file = File.read(File.expand_path('linked-plugins.styles.sass.erb', __dir__))
        template = ::ERB.new template_file, trim_mode: '-'

        puts "Regenerating frontend plugin sass #{file_register}."
        context = ::ProyeksiApp::Plugins::FrontendLinking::ErbContext.new plugins
        result = template.result(context.get_binding)
        File.open(file_register, 'w') { |file| file.write(result) }
      end

      ##
      # Print all gemspecs of registered OP plugins
      # from the :opf_plugins group.
      def load_known_opf_plugins
        bundler_groups = %i[opf_plugins]
        gemfile_path = Rails.root.join('Gemfile')

        gems = Bundler::Dsl.evaluate(gemfile_path, '_temp_lockfile', true)

        gems.dependencies
          .each_with_object({}) do |dep, l|
          l[dep.name] = dep if (bundler_groups & dep.groups).any?
        end
          .compact
      end
    end
  end
end
