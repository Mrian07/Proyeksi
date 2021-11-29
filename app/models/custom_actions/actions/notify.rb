#-- encoding: UTF-8



class CustomActions::Actions::Notify < CustomActions::Actions::Base
  include CustomActions::Actions::Strategies::Associated

  def apply(work_package)
    comment = principals.where(id: values).map do |p|
      prefix = if p.is_a?(User)
                 'user'
               else
                 'group'
               end

      "#{prefix}##{p.id}"
    end.join(', ')

    work_package.journal_notes = comment
  end

  def associated
    principals
      .map { |u| [u.id, u.name] }
  end

  def self.key
    :notify
  end

  def multi_value?
    true
  end

  private

  def principals
    Principal
      .not_locked
      .select(:id, :firstname, :lastname, :type)
      .ordered_by_name
  end
end
