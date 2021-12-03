#-- encoding: UTF-8

module Projects::Copy
  class CategoriesDependentService < Dependency
    def self.human_name
      I18n.t(:label_work_package_category_plural)
    end

    def source_count
      source.categories.count
    end

    protected

    def copy_dependency(params:)
      category_id_map = {}

      source.categories.find_each do |category|
        new_category = target.categories.create category.attributes.dup.except('id', 'project_id')

        category_id_map[category.id] = new_category.id
      end

      state.category_id_lookup = category_id_map
    end
  end
end
