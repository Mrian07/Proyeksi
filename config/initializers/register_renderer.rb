#-- encoding: UTF-8



ActionController::Renderers.add :csv do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.respond_to?(:to_csv) ? obj.to_csv : obj.to_s
  charset = "charset=#{I18n.t(:general_csv_encoding).downcase}"

  data = send_data str,
                   type: "#{Mime[:csv]}; header=present; #{charset};",
                   disposition: "attachment; filename=#{filename}"

  # For some reasons, the content-type header
  # does only contain the charset if the response
  # is manipulated like this.
  response.content_type += ''

  data
end
