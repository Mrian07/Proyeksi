#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      class UpdateFormRepresenter < FormRepresenter
        link :self do
          {
            href: api_v3_paths.work_package_form(represented.id),
            method: :post
          }
        end

        link :validate do
          {
            href: api_v3_paths.work_package_form(represented.id),
            method: :post
          }
        end

        link :previewMarkup do
          {
            href: api_v3_paths.render_markup(link: api_v3_paths.work_package(represented.id)),
            method: :post
          }
        end

        link :commit do
          if current_user.allowed_to?(:edit_work_packages, represented.project) &&
             @errors.empty?
            {
              href: api_v3_paths.work_package(represented.id),
              method: :patch
            }
          end
        end
      end
    end
  end
end
