#-- encoding: UTF-8


class AdminUserSeeder < Seeder
  def seed_data!
    user = new_admin
    unless user.save! validate: false
      puts 'Seeding admin failed:'
      user.errors.full_messages.each do |msg|
        puts "  #{msg}"
      end
    end
  end

  def applicable?
    User.not_builtin.admin.empty?
  end

  def not_applicable_message
    'No need to seed an admin as there already is one.'
  end

  def new_admin
    User.new.tap do |user|
      user.admin = true
      user.login = 'admin'
      user.password = 'admin'
      user.firstname = 'OpenProject'
      user.lastname = 'Admin'
      user.mail = ENV['ADMIN_EMAIL'].presence || 'admin@example.net'
      user.language = I18n.locale.to_s
      user.status = User.statuses[:active]
      user.force_password_change = force_password_change?
      user.notification_settings.build(involved: true, mentioned: true, watched: true)
    end
  end

  def force_password_change?
    Rails.env != 'development' && !force_password_change_disabled?
  end

  def force_password_change_disabled?
    off_values = ["off", "false", "no", "0"]

    off_values.include? ENV[force_password_change_env_switch_name]
  end

  def force_password_change_env_switch_name
    "OP_ADMIN_USER_SEEDER_FORCE_PASSWORD_CHANGE"
  end
end
