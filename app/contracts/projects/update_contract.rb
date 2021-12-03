module Projects
  class UpdateContract < BaseContract
    private

    def manage_permission
      :edit_project
    end
  end
end
