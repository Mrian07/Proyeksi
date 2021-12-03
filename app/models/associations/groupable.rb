#-- encoding: UTF-8

module Associations::Groupable
  def self.included(base)
    base.has_and_belongs_to_many :groups,
                                 foreign_key: 'user_id',
                                 join_table: "#{base.table_name_prefix}group_users#{base.table_name_suffix}",
                                 after_remove: ->(user, group) { group.user_removed(user) }
  end
end
