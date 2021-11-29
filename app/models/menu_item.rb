#-- encoding: UTF-8



class MenuItem < ApplicationRecord
  belongs_to :parent, class_name: 'MenuItem'
  has_many :children, -> {
    order('id ASC')
  }, class_name: 'MenuItem', dependent: :destroy, foreign_key: :parent_id

  serialize :options, Hash

  validates :title,
            presence: true,
            uniqueness: { scope: %i[navigatable_id type], case_sensitive: true }

  validates :name,
            presence: true,
            uniqueness: { scope: %i[navigatable_id parent_id], case_sensitive: true }

  def setting
    if new_record?
      :no_item
    elsif is_main_item?
      :main_item
    else
      :sub_item
    end
  end

  def is_main_item?
    parent_id.nil?
  end

  def is_sub_item?
    !parent_id.nil?
  end

  def is_only_main_item?
    self.class.main_items(wiki.id) == [self]
  end
end
