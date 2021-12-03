#-- encoding: UTF-8

#
# User for tasks like migrations
#

class SystemUser < User
  validate :validate_unique_system_user, on: :create

  # There should be only one SystemUser in the database
  def validate_unique_system_user
    errors.add :base, 'A SystemUser already exists.' if SystemUser.any?
  end

  # Overrides a few properties
  def logged?
    false
  end

  def builtin?
    true
  end

  def name(*_args)
    ; 'System'
  end

  def mail
    nil
  end

  def time_zone
    nil
  end

  def rss_key
    nil
  end

  def destroy
    false
  end

  def run_given
    User.execute_as(self) do
      yield self
    end
  end
end
