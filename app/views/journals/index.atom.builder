xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title title
  xml.link "rel" => "self", "href" => url_for(format: 'atom', key: User.current.rss_key, only_path: false)
  xml.link "rel" => "alternate", "href" => home_url(only_path: false)
  xml.id url_for(controller: '/homescreen', action: :index, only_path: false)
  xml.updated((journals.first ? journals.first.created_at : Time.now).xmlschema)
  xml.author { xml.name Setting.app_title.to_s }
  journals.each do |change|
    work_package = change.journable
    xml.entry do
      xml.title "#{work_package.project.name} - #{work_package.type.name} ##{work_package.id}: #{work_package.subject}"
      xml.link "rel" => "alternate", "href" => work_package_url(work_package)
      xml.id url_for(controller: '/work_packages', action: 'show', id: work_package, journal_id: change,
                     only_path: false)
      xml.updated change.created_at.xmlschema
      xml.author do
        xml.name change.user.name
        xml.email(change.user.mail) if change.user.is_a?(User) && !change.user.mail.blank? && !change.user.pref.hide_mail
      end
      xml.content "type" => "html" do
        xml.text! '<ul>'
        change.details.each do |detail|
          change_content = change.render_detail(detail, no_html: false)
          xml.text!(content_tag(:li, change_content)) if change_content.present?
        end
        xml.text! '</ul>'
        xml.text! format_text(change, :notes, only_path: false) unless change.notes.blank?
      end
    end
  end
end
