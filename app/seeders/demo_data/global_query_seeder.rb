#-- encoding: UTF-8


module DemoData
  class GlobalQuerySeeder < Seeder
    def initialize; end

    def seed_data!
      print_status '    ↳ Creating global queries' do
        seed_global_queries
      end
    end

    private

    def seed_global_queries
      Array(demo_data_for('global_queries')).each do |config|
        DemoData::QueryBuilder.new(config, nil).create!
      end
    end
  end
end
