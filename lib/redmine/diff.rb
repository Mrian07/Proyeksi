#-- encoding: UTF-8



module Redmine
  # A line of diff
  class Diff
    include ActionView::Helpers::TagHelper

    attr_accessor :nb_line_left, :line_left, :nb_line_right, :line_right, :type_diff_right, :type_diff_left, :offsets

    def initialize
      self.nb_line_left = ''
      self.nb_line_right = ''
      self.line_left = ''
      self.line_right = ''
      self.type_diff_right = ''
      self.type_diff_left = ''
    end

    def type_diff
      type_diff_right == 'diff_in' ? type_diff_right : type_diff_left
    end

    def line
      type_diff_right == 'diff_in' ? line_right : line_left
    end

    def html_line_left
      line_to_html(line_left, offsets)
    end

    def html_line_right
      line_to_html(line_right, offsets)
    end

    def html_line
      line_to_html(line, offsets)
    end

    def inspect
      puts '### Start Line Diff ###'
      puts nb_line_left
      puts line_left
      puts nb_line_right
      puts line_right
    end

    private

    def line_to_html(line, offsets)
      line_to_html_raw(line, offsets).tap do |html_str|
        html_str.force_encoding('UTF-8')
      end
    end

    def line_to_html_raw(line, offsets)
      return line unless offsets

      ActiveSupport::SafeBuffer.new.tap do |output|
        if offsets.first != 0
          output << line[0..offsets.first - 1]
        end

        output << content_tag(:span, line[offsets.first..offsets.last])

        unless offsets.last == -1
          output << line[offsets.last + 1..-1]
        end
      end.to_s
    end
  end
end
