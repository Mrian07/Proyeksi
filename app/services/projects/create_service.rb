#-- encoding: UTF-8



module Projects
  class CreateService < ::BaseServices::Create
    include Projects::Concerns::NewProjectService
  end
end
