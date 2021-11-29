#-- encoding: UTF-8



module MetaTagsHelper
  ##
  # Use meta-tags to output title and site name
  def output_title_and_meta_tags
    display_meta_tags site: Setting.app_title,
                      title: html_title_parts,
                      separator: ' | ', # Update the TitleService when changing this!
                      reverse: true
  end

  def initializer_meta_tag
    tag :meta,
        name: :openproject_initializer,
        data: {
          locale: I18n.locale,
          defaultLocale: I18n.default_locale,
          firstWeekOfYear: locale_first_week_of_year,
          firstDayOfWeek: locale_first_day_of_week,
          environment: Rails.env,
          edition: OpenProject::Configuration.edition
    }
  end

  ##
  # Writer of html_title as string
  def html_title(*args)
    raise "Don't use html_title getter" if args.empty?

    @html_title ||= []
    @html_title += args
  end

  ##
  # The html title parts currently defined
  def html_title_parts
    [].tap do |parts|
      parts << h(@project.name) if @project
      parts.concat @html_title.map(&:to_s) if @html_title
    end
  end
end
