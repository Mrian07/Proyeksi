#-- encoding: UTF-8



module BasicData
  module Documents
    class EnumerationSeeder < Seeder
      def seed_data!
        category_names.each do |name|
          DocumentCategory.create name: name
        end
      end

      def category_names
        category_i18n_keys.map { |key| I18n.t key }
      end

      def category_i18n_keys
        ['documentation', 'specification', 'other'].map do |name|
          ['enumeration', 'document_category', name].join('.')
        end
      end
    end
  end
end
