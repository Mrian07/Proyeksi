#-- encoding: UTF-8

class SCM::BaseRepositoryService
  def initialize(repository)
    self.repository = repository
  end

  private

  attr_accessor :repository
end
