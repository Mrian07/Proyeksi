#-- encoding: UTF-8

class Category < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_to, class_name: 'Principal', foreign_key: 'assigned_to_id'
  has_many :work_packages, foreign_key: 'category_id', dependent: :nullify

  validates :name,
            uniqueness: { scope: [:project_id], case_sensitive: false },
            length: { maximum: 255 }

  # validates that assignee is member of the issue category's project
  validates_each :assigned_to_id do |record, attr, value|
    if value && !(record.project.principals.map(&:id).include? value) # allow nil
      record.errors.add(attr, I18n.t(:error_must_be_project_member))
    end
  end

  alias :destroy_without_reassign :destroy

  # Destroy the category
  # If a category is specified, issues are reassigned to this category
  def destroy(reassign_to = nil)
    if reassign_to && reassign_to.is_a?(Category) && reassign_to.project == project
      WorkPackage.where("category_id = #{id}").update_all("category_id = #{reassign_to.id}")
    end
    destroy_without_reassign
  end

  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end
end
