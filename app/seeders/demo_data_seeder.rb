class DemoDataSeeder < CompositeSeeder
  def data_seeder_classes
    [
      DemoData::GroupSeeder,
      DemoData::AttributeHelpTextSeeder,
      DemoData::GlobalQuerySeeder,
      DemoData::ProjectSeeder,
      DemoData::OverviewSeeder
    ]
  end

  def namespace
    'DemoData'
  end
end
