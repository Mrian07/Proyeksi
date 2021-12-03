

require 'rails/generators'

class Generators::ProyeksiApp::Plugin::PluginGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  argument :plugin_name, type: :string, default: 'proyeksiapp-new-plugin'
  argument :root_folder, type: :string, default: 'vendor/gems'

  # every public method is run when the generator is invoked
  def generate_plugin
    plugin_dir
    lib_dir
    bin_dir
  end

  def full_name
    @full_name ||= begin
      "proyeksiapp-#{plugin_name}"
    end
  end

  private

  def raise_on_params
    puts plugin_name
    puts root_folder
  end

  def plugin_path
    "#{root_folder}/proyeksiapp-#{plugin_name}"
  end

  def plugin_dir
    @plugin_dir ||= begin
      directory('', plugin_path, recursive: false)
    end
  end

  def lib_path
    "#{plugin_path}/lib"
  end

  def lib_dir
    @lib_dir ||= begin
      directory('lib', lib_path)
    end
  end

  def bin_path
    "#{plugin_path}/bin"
  end

  def bin_dir
    @bin_dir ||= begin
      directory('bin', bin_path)
    end
  end
end
