#-- encoding: UTF-8



class Wikis::Annotate
  attr_reader :lines, :content

  def initialize(content)
    @content = content
    current = content
    current_lines = current.data.text.split(/\r?\n/)
    @lines = current_lines.map { |t| [nil, nil, t] }
    positions = []
    current_lines.size.times { |i| positions << i }
    while current.previous
      d = current.previous.data.text.split(/\r?\n/).diff(current.data.text.split(/\r?\n/)).diffs.flatten
      d.each_slice(3) do |s|
        sign = s[0]
        line = s[1]
        if sign == '+' && positions[line] && positions[line] != -1 && @lines[positions[line]][0].nil?
          @lines[positions[line]][0] = current.version
          @lines[positions[line]][1] = current.data.author
        end
      end
      d.each_slice(3) do |s|
        sign = s[0]
        line = s[1]
        if sign == '-'
          positions.insert(line, -1)
        else
          positions[line] = nil
        end
      end
      positions.compact!
      # Stop if every line is annotated
      break unless @lines.detect { |line| line[0].nil? }

      current = current.previous
    end
    @lines.each { |line| line[0] ||= current.version }
  end
end
