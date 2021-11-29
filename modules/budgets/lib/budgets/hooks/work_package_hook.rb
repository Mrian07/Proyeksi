

class Budgets::Hooks::WorkPackageHook < OpenProject::Hook::ViewListener
  # Updates the cost object after a move
  #
  # Context:
  # * params => Request parameters
  # * work_package => WorkPackage to move
  # * target_project => Target of the move
  # * copy => true, if the work_packages are copied rather than moved
  def controller_work_packages_move_before_save(context = {})
    # FIXME: In case of copy==true, this will break stuff if the original work_package is saved

    budget_id = context[:params] && context[:params][:budget_id]
    case budget_id
    when '' # a.k.a "(No change)"
      # cost objects HAVE to be changed if move is performed across project boundaries
      # as the are project specific
      context[:work_package].budget_id = nil unless context[:work_package].project == context[:target_project]
    when 'none'
      context[:work_package].budget_id = nil
    else
      context[:work_package].budget_id = budget_id
    end
  end

  # Saves the Cost Object assignment to the work_package
  #
  # Context:
  # * :work_package => WorkPackage being saved
  # * :params => HTML parameters
  #
  def controller_work_packages_bulk_edit_before_save(context = {})
    case true

    when context[:params][:budget_id].blank?
      # Do nothing
    when context[:params][:budget_id] == 'none'
      # Unassign budget
      context[:work_package].budget = nil
    else
      context[:work_package].budget = Budget.find(context[:params][:budget_id])
    end

    ''
  end
end
