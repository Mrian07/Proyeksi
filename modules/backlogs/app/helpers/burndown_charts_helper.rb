

module BurndownChartsHelper
  def yaxis_labels(burndown)
    max = burndown.max[:points]

    mvalue = (max / 25) + 1

    labels = (0..mvalue).map { |i| "[#{i * 25}, #{i * 25}]" }

    mvalue = mvalue + 1 if mvalue == 1 || ((max % 25) == 0)

    labels << "[#{mvalue * 25}, '<span class=\"axislabel\">#{I18n.t('backlogs.points')}</span>']"

    result = labels.join(', ')

    result.html_safe
  end

  def xaxis_labels(burndown)
    # 14 entries (plus the axis label) have come along as the best value for a good optical result.
    # Thus it is enough space between the entries.
    entries_displayed = (burndown.days.length / 14.0).ceil
    result = burndown.days.enum_for(:each_with_index).map do |d, i|
      if (i % entries_displayed) == 0
        "[#{i + 1}, '#{escape_javascript(::I18n.t('date.abbr_day_names')[d.wday % 7])} #{d.strftime('%d/%m')}']"
      end
    end.join(',').html_safe +
             ", [#{burndown.days.length + 1},
              '<span class=\"axislabel\">#{I18n.t('backlogs.date')}</span>']".html_safe
  end

  def dataseries(burndown)
    dataset = {}
    burndown.series.each do |s|
      dataset[s.first] = {
        label: I18n.t('backlogs.' + s.first.to_s),
        data: s.last.enum_for(:each_with_index).map { |val, i| [i + 1, val] }
      }
    end

    dataset
  end

  def burndown_series_checkboxes(burndown)
    boxes = ''
    burndown.series(:all).map { |s| s.first.to_s }.sort.each do |series|
      boxes += "<input class=\"series_enabled\" type=\"checkbox\" id=\"#{series}\" name=\"#{series}\" value=\"#{series}\" checked>#{I18n.t('backlogs.' + series.to_s)}<br/>"
    end
    boxes.html_safe
  end
end
