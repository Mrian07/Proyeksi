#-- encoding: UTF-8



module Projects
  class EnqueueCopyService < ::BaseServices::BaseCallable
    attr_reader :source, :user

    def initialize(user:, model: nil, **)
      @user = user
      @source = model
    end

    private

    def perform(params)
      call = test_copy(params)

      if call.success?
        ServiceResult.new success: true, result: schedule_copy_job(params)
      else
        call
      end
    end

    ##
    # Tests whether the copy can be performed
    def test_copy(params)
      test_params = params.merge(attributes_only: true)

      Projects::CopyService
        .new(user: user, source: source)
        .call(test_params)
    end

    ##
    # Schedule the project copy job
    def schedule_copy_job(params)
      CopyProjectJob.perform_later(user_id: user.id,
                                   source_project_id: source.id,
                                   target_project_params: params[:target_project_params],
                                   associations_to_copy: params[:only].to_a,
                                   send_mails: ActiveRecord::Type::Boolean.new.cast(params[:send_notifications]))
    end
  end
end
