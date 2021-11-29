#-- encoding: UTF-8



module Redmine
  # Class used to parse unified diffs
  class UnifiedDiff < Array
    attr_reader :diff_type

    def initialize(diff, options = {})
      options.assert_valid_keys(:type, :max_lines)
      diff = diff.split("\n") if diff.is_a?(String)
      @diff_type = options[:type] || 'inline'
      lines = 0
      @truncated = false
      diff_table = DiffTable.new(@diff_type)
      diff.each do |line|
        line_encoding = nil
        if line.respond_to?(:force_encoding)
          line_encoding = line.encoding
          # TODO: UTF-16 and Japanese CP932 which is incompatible with ASCII
          #       In Japan, difference between file path encoding
          #       and file contents encoding is popular.
          line.force_encoding('ASCII-8BIT')
        end
        unless diff_table.add_line line
          line.force_encoding(line_encoding) if line_encoding
          self << diff_table if diff_table.length > 0
          diff_table = DiffTable.new(diff_type)
        end
        lines += 1
        if options[:max_lines] && lines > options[:max_lines]
          @truncated = true
          break
        end
      end
      self << diff_table unless diff_table.empty?
      self
    end

    def truncated?; @truncated; end
  end
end
