#-- encoding: UTF-8



module ::Bim::Queries::WorkPackages::Columns
  class BcfThumbnailColumn < Queries::WorkPackages::Columns::WorkPackageColumn
    def caption
      I18n.t('attributes.bcf_thumbnail')
    end

    def self.instances(_context = nil)
      return [] unless OpenProject::Configuration.bim?

      [new(:bcf_thumbnail, { summable: false, groupable: false, sortable: false })]
    end
  end
end
