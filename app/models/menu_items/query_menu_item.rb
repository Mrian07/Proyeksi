#-- encoding: UTF-8



class MenuItems::QueryMenuItem < MenuItem
  belongs_to :query, foreign_key: 'navigatable_id'

  def unique_name
    "#{name}-#{id}".to_sym
  end
end
