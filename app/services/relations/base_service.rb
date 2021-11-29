#-- encoding: UTF-8



class Relations::BaseService < ::BaseServices::BaseCallable
  include Contracted
  include Shared::ServiceContext

  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  private

  def update_relation(model, attributes)
    model.attributes = model.attributes.merge attributes

    success, errors = validate_and_save(model, user)
    success, errors = retry_with_inverse_for_relates(model, errors) unless success

    result = ServiceResult.new success: success, errors: errors, result: model

    if success && model.follows?
      reschedule_result = reschedule(model)
      result.merge!(reschedule_result)
    end

    result
  end

  def set_defaults(model)
    if Relation::TYPE_FOLLOWS == model.relation_type
      model.delay ||= 0
    else
      model.delay = nil
    end
  end

  def reschedule(model)
    schedule_result = WorkPackages::SetScheduleService
                      .new(user: user, work_package: model.to)
                      .call

    # The to-work_package will not be altered by the schedule service so
    # we do not have to save the result of the service.
    save_result = if schedule_result.success?
                    schedule_result.dependent_results.all? { |dr| !dr.result.changed? || dr.result.save }
                  end || false

    schedule_result.success = save_result

    schedule_result
  end

  def retry_with_inverse_for_relates(model, errors)
    if errors.symbols_for(:base).include?(:"typed_dag.circular_dependency") &&
       model.canonical_type == Relation::TYPE_RELATES
      model.from, model.to = model.to, model.from

      validate_and_save(model, user)
    else
      [false, errors]
    end
  end
end
