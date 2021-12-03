#-- encoding: UTF-8

class Queries::BaseService
  include Contracted

  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call(query)
    result, errors = validate_and_save(query, user)

    service_result result, errors, query
  end

  private

  def service_result(result, errors, query)
    ServiceResult.new success: result, errors: errors, result: query
  end
end
