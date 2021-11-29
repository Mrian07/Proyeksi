#-- encoding: UTF-8


module Bim
  class BasicDataSeeder < ::BasicDataSeeder
    def data_seeder_classes
      [
        ::BasicData::BuiltinRolesSeeder,
        ::Bim::BasicData::RoleSeeder,
        ::Bim::BasicData::ActivitySeeder,
        ::BasicData::ColorSeeder,
        ::BasicData::ColorSchemeSeeder,
        ::Bim::BasicData::WorkflowSeeder,
        ::Bim::BasicData::PrioritySeeder,
        ::Bim::BasicData::SettingSeeder,
        ::Bim::BasicData::ThemeSeeder
      ]
    end
  end
end
