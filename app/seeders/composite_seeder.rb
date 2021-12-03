class CompositeSeeder < Seeder
  def seed_data!
    ActiveRecord::Base.transaction do
      data_seeders.each do |seeder|
        puts " ↳ #{seeder.class.name.demodulize}"
        seeder.seed!
      end

      return if discovered_seeders.empty?

      puts "   Loading discovered seeders: "
      discovered_seeders.each do |seeder|
        puts " ↳ #{seeder.class.name.demodulize}"
        seeder.seed!
      end
    end
  end

  def data_seeders
    data_seeder_classes.map(&:new)
  end

  def data_seeder_classes
    raise NotImplementedError, 'has to be implemented by subclasses'
  end

  def discovered_seeders
    discovered_seeder_classes.map(&:new)
  end

  ##
  # Discovered seeders defined outside of the core (i.e. in plugins).
  #
  # Seeders defined in the core have a simple namespace, e.g. 'BasicData'
  # or 'DemoData'. Plugins must define their seeders in their own namespace,
  # e.g. 'BasicData::Documents' in order to avoid name conflicts.
  def discovered_seeder_classes
    Seeder
      .subclasses
      .reject { |cl| cl.to_s.deconstantize == namespace }
      .select { |cl| include_discovered_class? cl }
  end

  def namespace
    raise NotImplementedError, 'has to be implemented by subclasses'
  end

  ##
  # Accepts plugin seeders, e.g. 'BasicData::Documents'.
  def include_discovered_class?(discovered_class)
    discovered_class.name =~ /^#{namespace}::/
  end
end
