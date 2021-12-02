

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  first_item = @items.first
  first_item_event = !first_item.nil? && first_item.respond_to?(:data) ? first_item.data : first_item
  updated_time = first_item_event.nil? ? Time.now : first_item_event.event_datetime

  xml.title   truncate_single_line(@title, length: 100)
  xml.link    "rel" => "self", "href" => url_for(only_path: false)
  xml.link    "rel" => "alternate", "href" => url_for(only_path: false, format: nil, key: nil)
  xml.id      url_for(controller: '/homescreen', action: :index, only_path: false)
  xml.updated(updated_time.xmlschema)
  xml.author { xml.name Setting.app_title }
  xml.generator(uri: ProyeksiApp::Info.url) { xml.text! ProyeksiApp::Info.app_name; }
  @items.each do |item|
    item_event = !first_item.nil? && first_item.respond_to?(:data) ? item.data : item

    xml.entry do
      url = if item_event.is_a? Activities::Event
              item_event.event_url
            else
              url_for(item_event.event_url(only_path: false))
            end
      if @project
        xml.title truncate_single_line(item_event.event_title, length: 100)
      else
        xml.title truncate_single_line("#{item.project} - #{item_event.event_title}", length: 100)
      end
      xml.link "rel" => "alternate", "href" => url
      xml.id url
      xml.updated item_event.event_datetime.xmlschema
      author = item_event.event_author if item_event.respond_to?(:event_author)
      if author
        xml.author do
          xml.name(author)
          xml.email(author.mail) if author.is_a?(User) && !author.mail.blank? && !author.pref.hide_mail
        end
      end
      xml.content "type" => "html" do
        xml.text! format_text(item_event, :event_description, only_path: false)
      end
    end
  end
end
