class ConvertToMarkdown < ActiveRecord::Migration[5.1]
  def up
    setting = Setting.where(name: 'text_formatting').pluck(:value)
    return unless setting && setting[0] == 'textile'

    if ENV['PROYEKSIAPP_SKIP_TEXTILE_MIGRATION'].present?
      warn <<~WARNING
        Your instance is configured with Textile text formatting, this means you have likely been running ProyeksiApp before 8.0.0

        Since you have requested skip the textile migration, your data will NOT be converted. You can do this in a subsequent step:

        $> bundle exec rails runner "ProyeksiApp::TextFormatting::Formats::Markdown::TextileConverter.new.run!"

        or in a packaged installation:

        $> proyeksiapp run bundle exec rails runner "ProyeksiApp::TextFormatting::Formats::Markdown::TextileConverter.new.run!"

        For more information, please visit this page: https://www.proyeksiapp.org/textile-to-markdown-migration

      WARNING
      return
    end

    if setting && setting[0] == 'textile'
      converter = ProyeksiApp::TextFormatting::Formats::Markdown::TextileConverter.new
      converter.run!
    end

    Setting.where(name: %w(text_formatting use_wysiwyg)).delete_all
  end
end
