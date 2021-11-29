#-- encoding: UTF-8



# Seeds the minimum data required to run OpenProject (BasicDataSeeder, AdminUserSeeder)
# as well as optional demo data (DemoDataSeeder) to give a user some orientation.

class RootSeeder < Seeder
  include Redmine::I18n

  def initialize(seed_development_data: Rails.env.development?)
    require 'basic_data_seeder'
    require 'demo_data_seeder'
    require 'development_data_seeder'

    @seed_development_data = seed_development_data

    rails_engines.each { |engine| load_engine_seeders! engine }
  end

  def seed_data!
    reset_active_record!
    set_locale!
    prepare_seed!

    do_seed!
  end

  def do_seed!
    ActiveRecord::Base.transaction do
      # Basic data needs be seeded before anything else.
      seed_basic_data

      puts '*** Seeding admin user'
      AdminUserSeeder.new.seed!

      puts '*** Seeding demo data'
      DemoDataSeeder.new.seed!

      if seed_development_data?
        seed_development_data
      end

      rails_engines.each do |engine|
        puts "*** Loading #{engine.engine_name} seed data"
        engine.load_seed
      end
    end
  end

  def seed_development_data?
    @seed_development_data
  end

  def rails_engines
    ::Rails::Engine.subclasses.map(&:instance)
  end

  def load_engine_seeders!(engine)
    Dir[engine.root.join('app/seeders/**/*.rb')]
      .each { |file| require file }
  end

  ##
  # Clears some schema caches and column information.
  def reset_active_record!
    ActiveRecord::Base.descendants.each do |klass|
      klass.connection.schema_cache.clear!
      klass.reset_column_information
    end
  end

  def set_locale!
    # willfully ignoring Redmine::I18n and it's
    # #set_language_if_valid here as it
    # would mean to circumvent the default settings
    # for valid_languages.
    desired_lang = (ENV['LOCALE'] || :en).to_sym

    if all_languages.include?(desired_lang)
      I18n.locale = desired_lang
      puts "*** Seeding for locale: '#{I18n.locale}'"
    else
      raise "Locale #{desired_lang} is not supported"
    end
  end

  def prepare_seed!
    # Disable mail delivery for the duration of this task
    ActionMailer::Base.perform_deliveries = false

    # Avoid asynchronous DeliverWorkPackageCreatedJob
    Delayed::Worker.delay_jobs = false
  end

  private

  def seed_development_data
    puts '*** Seeding development data'
    require 'factory_bot'
    # Load FactoryBot factories
    begin
      ::FactoryBot.find_definitions
    rescue StandardError => e
      raise e unless e.message.downcase.include? "factory already registered"
    end

    DevelopmentDataSeeder.new.seed!
  end

  def seed_basic_data
    puts "*** Seeding basic data for #{OpenProject::Configuration['edition']} edition"
    ::StandardSeeder::BasicDataSeeder.new.seed!
  end
end