

class WorkPackageBoxesController < WorkPackagesController
  helper :rb_common

  def show
    return redirect_to work_package_path(params[:id]) unless request.xhr?

    load_journals
    @changesets = @work_package.changesets.visible.all
    @changesets.reverse! if User.current.wants_comments_in_reverse_order?
    @relations = @work_package.relations.select do |r|
      r.other_work_package(@work_package) && r.other_work_package(@work_package).visible?
    end
    @allowed_statuses = WorkPackages::UpdateContract.new(work_package, User.current).assignable_statuses
    @edit_allowed = User.current.allowed_to?(:edit_work_packages, @project)
    @priorities = IssuePriority.all
    @time_entry = TimeEntry.new

    respond_to do |format|
      format.js   { render partial: 'show' }
    end
  end

  def edit
    return redirect_to edit_work_package_path(params[:id]) unless request.xhr?

    update_work_package_from_params
    load_journals
    @journal = @work_package.last_journal

    respond_to do |format|
      format.js   { render partial: 'edit' }
    end
  end

  def update
    update_work_package_from_params

    if @work_package.save_work_package_with_child_records(params, @time_entry)
      @work_package.reload
      load_journals
      respond_to do |format|
        format.js   { render partial: 'show' }
      end
    else
      @journal = @work_package.last_journal
      respond_to do |format|
        format.js { render partial: 'edit' }
      end
    end
  end

  private

  def load_journals
    @journals = @work_package.journals.includes(:user).order("#{Journal.table_name}.created_at ASC")
    @journals.reverse! if User.current.wants_comments_in_reverse_order?
  end
end
