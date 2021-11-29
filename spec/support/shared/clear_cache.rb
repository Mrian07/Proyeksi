#-- encoding: UTF-8



RSpec.configure do |config|
  config.around(:each) do |example|
    clear_cache = example.metadata[:clear_cache]
    OpenProject::Cache.clear if clear_cache

    example.run

    OpenProject::Cache.clear if clear_cache
  end
end
