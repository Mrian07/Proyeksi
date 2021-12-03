class UserJob < ApplicationJob
  attr_reader :user

  def perform(user:, **args)
    @user = user

    User.execute_as(user) do
      execute(**args)
    end
  rescue StandardError => e
    Rails.logger.error "Failed to execute job #{self.class.name} for #{user}: #{e}"
    raise e
  end
end
