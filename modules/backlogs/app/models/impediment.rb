

class Impediment < Task
  extend OpenProject::Backlogs::Mixins::PreventIssueSti

  after_save :update_blocks_list

  validate :validate_blocks_list

  def self.default_scope
    roots
      .where(type_id: type)
  end

  def blocks_ids=(ids)
    @blocks_ids_list = [ids] if ids.is_a?(Integer)
    @blocks_ids_list = ids.split(/\D+/).map(&:to_i) if ids.is_a?(String)
    @blocks_ids_list = ids.map(&:to_i) if ids.is_a?(Array)
  end

  def blocks_ids
    @blocks_ids_list ||= block_ids
  end

  private

  def update_blocks_list
    self.block_ids = blocks_ids
  end

  def validate_blocks_list
    if blocks_ids.size == 0
      errors.add :blocks_ids, :must_block_at_least_one_work_package
    else
      other_version_ids = WorkPackage.where(id: blocks_ids).pluck(:version_id).uniq
      if other_version_ids.size != 1 || other_version_ids[0] != version_id
        errors.add :blocks_ids,
                   :can_only_contain_work_packages_of_current_sprint
      end
    end
  end
end
