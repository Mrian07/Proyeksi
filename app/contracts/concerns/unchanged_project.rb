#-- encoding: UTF-8



module UnchangedProject
  extend ActiveSupport::Concern

  included do
    def with_unchanged_project_id
      if model.project_id_changed?
        current_project_id = model.project_id

        model.project_id = model.project_id_was

        begin
          yield
        ensure
          model.project_id = current_project_id
        end
      else
        yield
      end
    end
  end
end
