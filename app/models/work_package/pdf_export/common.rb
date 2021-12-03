#-- encoding: UTF-8



module WorkPackage::PDFExport::Common
  include Redmine::I18n
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper
  include CustomFieldsHelper
  include ProyeksiApp::TextFormatting

  private

  def get_pdf(_language)
    ::WorkPackage::PDFExport::View.new(current_language)
  end

  def field_value(work_package, attribute)
    value = work_package.send(attribute)

    case value
    when Date
      format_date value
    when Time
      format_time value
    else
      value.to_s
    end
  end

  def success(content)
    ::Exports::Result
      .new format: :csv,
           title: title,
           content: content,
           mime_type: 'application/pdf'
  end

  def error(message)
    raise ::Exports::ExportError.new message
  end

  def cell_padding
    @cell_padding ||= [2, 5, 2, 5]
  end

  def configure_markup
    # Do not attempt to fetch images.
    # Fetching images can cause errors e.g. a 403 is returned when attempting to fetch from aws with
    # a no longer valid token.
    # Such an error would cause the whole export to error.
    pdf.markup_options = {
      image: {
        loader: ->(_src) { nil },
        placeholder: "<i>[#{I18n.t('export.image.omitted')}]</i>"
      }
    }
  end

  def current_y_position
    OpenStruct.new y: pdf.y, page: pdf.page_number
  end

  def position_diff(position_a, position_b)
    position_a.y - position_b.y + (position_b.page - position_a.page) * pdf.bounds.height
  end
end
