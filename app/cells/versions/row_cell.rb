

module Versions
  class RowCell < ::RowCell
    include VersionsHelper

    # Overriding cell's method to set the project instance variable.
    # A lot of helpers rely on the existence of it.
    def setup!(model, options)
      instance_variable_set(:@project, options[:table].project) if options[:table].project

      super
    end

    def version
      model
    end

    def project
      version.project
    end

    def row_css_class
      shared = "shared" if version.project != table.project

      ["version", shared].compact.join(" ")
    end

    def name
      link_to_version version, {}, project: version.project
    end

    def start_date
      format_date(version.start_date)
    end

    def effective_date
      format_date(version.effective_date)
    end

    def description
      h(version.description)
    end

    def status
      t("version_status_#{version.status}")
    end

    def sharing
      h(format_version_sharing(version.sharing))
    end

    def wiki_page
      return '' if wiki_page_title.blank? || version.project.wiki.nil?

      link_to_if_authorized(wiki_page_title,
                            controller: '/wiki',
                            action: 'show',
                            project_id: version.project,
                            id: wiki_page_title) || h(wiki_page_title)
    end

    def button_links
      [edit_link, delete_link, backlogs_edit_link].compact
    end

    private

    def wiki_page_title
      version.wiki_page_title
    end

    def edit_link
      return unless version.project == table.project

      link_to_if_authorized '',
                            { controller: '/versions', action: 'edit', id: version },
                            class: 'icon icon-edit',
                            title: t(:button_edit)
    end

    def delete_link
      return unless version.project == table.project

      link_to_if_authorized '',
                            { controller: '/versions', action: 'destroy', id: version },
                            data: { confirm: t(:text_are_you_sure) },
                            method: :delete,
                            class: 'icon icon-delete',
                            title: t(:button_delete)
    end

    def column_css_class(column)
      if column == :name
        super.to_s + name_css_class
      else
        super
      end
    end

    def name_css_class
      classes = " #{version.status}"

      if version.project != table.project
        classes += " icon-context icon-link"
      end

      classes
    end
  end
end
