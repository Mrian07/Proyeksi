

module ProyeksiApp::PDFExport::ExportCard
  class GroupElement
    include ProyeksiApp::PDFExport::Exceptions

    def initialize(pdf, orientation, config, work_package)
      @pdf = pdf
      @orientation = orientation
      @config = config
      @rows_config = config["rows"]
      @work_package = work_package
      @row_elements = []

      current_y_offset = 0
      row_heights = @orientation[:row_heights]

      @rows_config.each_with_index do |(_r_key, r_value), i|
        current_y_offset += (row_heights[i - 1]) if i > 0
        row_orientation = {
          y_offset: @orientation[:height] - current_y_offset,
          x_offset: 0,
          width: @orientation[:width] - (@orientation[:group_padding] * 2),
          height: row_heights[i],
          text_padding: @orientation[:text_padding]
        }

        @row_elements << RowElement.new(@pdf, row_orientation, r_value, @work_package)
      end
    end

    def draw
      padding = @orientation[:group_padding]
      top_left = [@orientation[:x_offset] + padding, @orientation[:y_offset]]
      bounds = @orientation.slice(:width, :height)
      bounds[:width] -= padding * 2

      @pdf.bounding_box(top_left, bounds) do
        @pdf.stroke_color '000000'

        # Draw rows
        @row_elements.each do |row|
          row.draw
        end

        if @config["has_border"] or false
          @pdf.stroke_bounds
        end
      end
    end
  end
end
