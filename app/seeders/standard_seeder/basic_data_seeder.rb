#-- encoding: UTF-8

module StandardSeeder
  class BasicDataSeeder < ::BasicDataSeeder
    def data_seeder_classes
      [
        ::BasicData::BuiltinRolesSeeder,
        ::BasicData::RoleSeeder,
        ::StandardSeeder::BasicData::ActivitySeeder,
        ::BasicData::ColorSeeder,
        ::BasicData::ColorSchemeSeeder,
        ::StandardSeeder::BasicData::WorkflowSeeder,
        ::StandardSeeder::BasicData::PrioritySeeder,
        ::BasicData::SettingSeeder
      ]
    end
  end
end
