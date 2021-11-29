#-- encoding: UTF-8



module Redmine
  # Class that represents a file diff
  class DiffTable < Array
    attr_reader :file_name

    # Initialize with a Diff file and the type of Diff View
    # The type view must be inline or sbs (side_by_side)
    def initialize(type = 'inline')
      @parsing = false
      @added = 0
      @removed = 0
      @type = type
    end

    # Function for add a line of this Diff
    # Returns false when the diff ends
    def add_line(line)
      if @parsing
        if line =~ /^[^+\-\s@\\]/
          @parsing = false
          return false
        elsif line =~ /^@@ (\+|-)(\d+)(,\d+)? (\+|-)(\d+)(,\d+)? @@/
          @line_num_l = $2.to_i
          @line_num_r = $5.to_i
        else
          parse_line(line, @type)
        end
      elsif line =~ /^(---|\+\+\+) (.*)$/
        @file_name = $2
      elsif line =~ /^@@ (\+|-)(\d+)(,\d+)? (\+|-)(\d+)(,\d+)? @@/
        @line_num_l = $2.to_i
        @line_num_r = $5.to_i
        @parsing = true
      end
      true
    end

    def each_line
      prev_line_left = nil
      prev_line_right = nil
      each do |line|
        spacing = prev_line_left && prev_line_right && (line.nb_line_left != prev_line_left + 1) && (line.nb_line_right != prev_line_right + 1)
        yield spacing, line
        prev_line_left = line.nb_line_left.to_i if line.nb_line_left.to_i > 0
        prev_line_right = line.nb_line_right.to_i if line.nb_line_right.to_i > 0
      end
    end

    def inspect
      puts '### DIFF TABLE ###'
      puts "file : #{file_name}"
      each(&:inspect)
    end

    private

    # Escape the HTML for the diff
    def escapeHTML(line)
      CGI.escapeHTML(line)
    end

    def diff_for_added_line
      if @type == 'sbs' && @removed > 0 && @added < @removed
        self[-(@removed - @added)]
      else
        diff = Diff.new
        self << diff
        diff
      end
    end

    def parse_line(line, _type = 'inline')
      if line[0, 1] == '+'
        diff = diff_for_added_line
        diff.line_right = line[1..-1]
        diff.nb_line_right = @line_num_r
        diff.type_diff_right = 'diff_in'
        @line_num_r += 1
        @added += 1
        true
      elsif line[0, 1] == '-'
        diff = Diff.new
        diff.line_left = line[1..-1]
        diff.nb_line_left = @line_num_l
        diff.type_diff_left = 'diff_out'
        self << diff
        @line_num_l += 1
        @removed += 1
        true
      else
        write_offsets
        if line[0, 1] =~ /\s/
          diff = Diff.new
          diff.line_right = line[1..-1]
          diff.nb_line_right = @line_num_r
          diff.line_left = line[1..-1]
          diff.nb_line_left = @line_num_l
          self << diff
          @line_num_l += 1
          @line_num_r += 1
          true
        elsif line[0, 1] = '\\'
          true
        else
          false
        end
      end
    end

    def write_offsets
      if @added > 0 && @added == @removed
        @added.times do |i|
          line = self[-(1 + i)]
          removed = @type == 'sbs' ? line : self[-(1 + @added + i)]
          offsets = offsets(removed.line_left, line.line_right)
          removed.offsets = line.offsets = offsets
        end
      end
      @added = 0
      @removed = 0
    end

    def offsets(line_left, line_right)
      if line_left.present? && line_right.present? && line_left != line_right
        max = [line_left.size, line_right.size].min
        starting = 0
        while starting < max && line_left[starting] == line_right[starting]
          starting += 1
        end
        ending = -1
        while ending >= -(max - starting) && (line_left[ending] == line_right[ending])
          ending -= 1
        end
        unless starting == 0 && ending == -1
          [starting, ending]
        end
      end
    end
  end
end
