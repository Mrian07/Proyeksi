#-- encoding: UTF-8



RSpec.configure do |config|
  config.around(:each) do |example|
    clear_cache = example.metadata[:clear_cache]
    ProyeksiApp::Cache.clear if clear_cache

    example.run

    ProyeksiApp::Cache.clear if clear_cache
  end
end
