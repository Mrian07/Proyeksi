class WorkPackagePolicy < BasePolicy
  private

  def cache(work_package)
    @cache ||= Hash.new do |wp_hash, wp|
      wp_hash[wp] = Hash.new do |project_hash, project|
        project_hash[project] = allowed_hash(wp)
      end
    end

    @cache[work_package][work_package.project]
  end

  def allowed_hash(work_package)
    # copy checks for the move_work_packages permission. This makes
    # sense only because the work_packages/moves controller handles
    # copying multiple work packages.
    {
      edit: edit_allowed?(work_package),
      log_time: log_time_allowed?(work_package),
      move: move_allowed?(work_package),
      copy: move_allowed?(work_package),
      duplicate: copy_allowed?(work_package), # duplicating is another form of copying
      delete: delete_allowed?(work_package),
      manage_subtasks: manage_subtasks_allowed?(work_package),
      comment: comment_allowed?(work_package),
      assign_version: assign_version_allowed?(work_package)
    }
  end

  def edit_allowed?(work_package)
    @edit_cache ||= Hash.new do |hash, project|
      hash[project] = work_package.persisted? && user.allowed_to?(:edit_work_packages, project)
    end

    @edit_cache[work_package.project]
  end

  def log_time_allowed?(work_package)
    @log_time_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:log_time, project)
    end

    @log_time_cache[work_package.project]
  end

  def move_allowed?(work_package)
    @move_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:move_work_packages, project)
    end

    @move_cache[work_package.project]
  end

  def copy_allowed?(work_package)
    type_active_in_project?(work_package) && add_allowed?(work_package)
  end

  def delete_allowed?(work_package)
    @delete_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:delete_work_packages, project)
    end

    @delete_cache[work_package.project]
  end

  def add_allowed?(work_package)
    @add_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:add_work_packages, project)
    end

    @add_cache[work_package.project]
  end

  def type_active_in_project?(work_package)
    return false unless work_package.project

    @type_active_cache ||= Hash.new do |hash, project|
      hash[project] = project.types.pluck(:id)
    end

    @type_active_cache[work_package.project].include?(work_package.type_id)
  end

  def manage_subtasks_allowed?(work_package)
    @manage_subtasks_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:manage_subtasks, work_package.project, global: work_package.project.nil?)
    end

    @manage_subtasks_cache[work_package.project]
  end

  def comment_allowed?(work_package)
    @comment_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:add_work_package_notes, work_package.project) ||
        edit_allowed?(work_package)
    end

    @comment_cache[work_package.project]
  end

  def assign_version_allowed?(work_package)
    @assign_version_cache ||= Hash.new do |hash, project|
      hash[project] = user.allowed_to?(:assign_versions, work_package.project)
    end

    @assign_version_cache[work_package.project]
  end
end
