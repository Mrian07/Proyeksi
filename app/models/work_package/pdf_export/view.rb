#-- encoding: UTF-8

class WorkPackage::PDFExport::View
  include Prawn::View
  include Redmine::I18n

  def initialize(lang)
    set_language_if_valid lang
  end

  def options
    @options ||= {}
  end

  def info
    @info ||= {
      Creator: ProyeksiApp::Info.app_name,
      CreationDate: Time.now
    }
  end

  def document
    @document ||= Prawn::Document.new(options.merge(info: info)).tap do |document|
      register_fonts! document

      document.set_font document.font('NotoSans')
      document.fallback_fonts = fallback_fonts
    end
  end

  def fallback_fonts
    []
  end

  def register_fonts!(document)
    font_path = Rails.root.join('public/fonts')

    document.font_families['NotoSans'] = {
      normal: {
        file: font_path.join('noto/NotoSans-Regular.ttf'),
        font: 'NotoSans-Regular'
      },
      italic: {
        file: font_path.join('noto/NotoSans-Italic.ttf'),
        font: 'NotoSans-Italic'
      },
      bold: {
        file: font_path.join('noto/NotoSans-Bold.ttf'),
        font: 'NotoSans-Bold'
      },
      bold_italic: {
        file: font_path.join('noto/NotoSans-BoldItalic.ttf'),
        font: 'NotoSans-BoldItalic'
      }
    }
  end

  def title=(title)
    info[:Title] = title
  end

  def title
    info[:Title]
  end

  def font(name: nil, style: nil, size: nil)
    name ||= document.font.basename.split('-').first # e.g. NotoSans-Bold => NotoSans
    font_opts = {}
    font_opts[:style] = style if style

    document.font name, font_opts
    document.font_size size if size

    document.font
  end
end
