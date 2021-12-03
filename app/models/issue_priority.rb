#-- encoding: UTF-8

class IssuePriority < Enumeration
  has_many :work_packages, foreign_key: 'priority_id'
  belongs_to :color

  OptionName = :enumeration_work_package_priorities

  def self.colored?
    true
  end

  def color_label
    I18n.t('prioritiies.edit.priority_color_text')
  end

  def option_name
    OptionName
  end

  def objects_count
    work_packages.count
  end

  def transfer_relations(to)
    work_packages.update_all(priority_id: to.id)
  end
end
