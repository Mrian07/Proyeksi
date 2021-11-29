#-- encoding: UTF-8


class DevelopmentDataSeeder < CompositeSeeder
  def data_seeder_classes
    [
      DevelopmentData::UsersSeeder,
      DevelopmentData::CustomFieldsSeeder,
      DevelopmentData::ProjectsSeeder
      # DevelopmentData::WorkPackageSeeder
    ]
  end

  def namespace
    'DevelopmentData'
  end
end
