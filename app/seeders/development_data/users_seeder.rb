#-- encoding: UTF-8

module DevelopmentData
  class UsersSeeder < Seeder
    def seed_data!
      puts 'Seeding development users ...'
      user_names.each do |login|
        user = new_user login.to_s

        if login == :admin_de
          user.language = 'de'
          user.admin = true
        end

        unless user.save! validate: false
          puts "Seeding #{login} user failed:"
          user.errors.full_messages.each do |msg|
            puts "  #{msg}"
          end
        end
      end
    end

    def applicable?
      !seed_users_disabled? && User.where(login: user_names).count === 0
    end

    def seed_users_disabled?
      off_values = ["off", "false", "no", "0"]

      off_values.include? ENV['OP_DEV_USER_SEEDER_ENABLED']
    end

    def user_names
      %i(reader member project_admin admin_de)
    end

    def not_applicable_message
      msg = 'Not seeding development users.'
      msg << ' seed users disabled through ENV' if seed_users_disabled?

      msg
    end

    def new_user(login)
      User.new.tap do |user|
        user.login = login
        user.password = login
        user.firstname = login.humanize
        user.lastname = 'DEV user'
        user.mail = "#{login}@example.net"
        user.status = User.statuses[:active]
        user.language = I18n.locale
        user.force_password_change = false
      end
    end

    def force_password_change?
      Rails.env != 'development' && !force_password_change_disabled?
    end

    def force_password_change_disabled?
      off_values = ["off", "false", "no", "0"]

      off_values.include? ENV[force_password_change_env_switch_name]
    end
  end
end
