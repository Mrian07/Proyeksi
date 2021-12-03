#-- encoding: UTF-8

class BasicDataSeeder < CompositeSeeder
  def data_seeder_classes
    raise NotImplementedError
  end

  def namespace
    'BasicData'
  end
end
