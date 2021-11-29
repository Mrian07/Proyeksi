

namespace :random_data do
  desc 'seeds the data base wth random data'
  task seed: :environment do
    puts '*** Seeding basic data'
    BasicDataSeeder.seed!

    puts '*** Seeding admin user'
    AdminUserSeeder.new.seed!

    puts '*** Seeding demo data'
    RandomDataSeeder.seed!

    ::Rails::Engine.subclasses.map(&:instance).each do |engine|
      puts "*** Loading #{engine.engine_name} seed data"
      engine.load_seed
    end
  end
end
