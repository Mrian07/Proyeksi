#-- encoding: UTF-8



ProyeksiApp::CustomFieldFormat.map do |fields|
  fields.register ProyeksiApp::CustomFieldFormat.new('string',
                                                     label: :label_string,
                                                     order: 1)
  fields.register ProyeksiApp::CustomFieldFormat.new('text',
                                                     label: :label_text,
                                                     order: 2,
                                                     formatter: 'CustomValue::FormattableStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('int',
                                                     label: :label_integer,
                                                     order: 3,
                                                     formatter: 'CustomValue::IntStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('float',
                                                     label: :label_float,
                                                     order: 4,
                                                     formatter: 'CustomValue::FloatStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('list',
                                                     label: :label_list,
                                                     order: 5,
                                                     formatter: 'CustomValue::ListStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('date',
                                                     label: :label_date,
                                                     order: 6,
                                                     formatter: 'CustomValue::DateStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('bool',
                                                     label: :label_boolean,
                                                     order: 7,
                                                     formatter: 'CustomValue::BoolStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('user',
                                                     label: Proc.new { User.model_name.human },
                                                     only: %w(WorkPackage TimeEntry
                                                              Version Project),
                                                     edit_as: 'list',
                                                     order: 8,
                                                     formatter: 'CustomValue::UserStrategy')
  fields.register ProyeksiApp::CustomFieldFormat.new('version',
                                                     label: Proc.new { Version.model_name.human },
                                                     only: %w(WorkPackage TimeEntry
                                                              Version Project),
                                                     edit_as: 'list',
                                                     order: 9,
                                                     formatter: 'CustomValue::VersionStrategy')
  # This is an internal formatter used as a fallback in case a value is not found.
  # Setting the label to nil in order to avoid it becoming available for selection as a custom value format.
  fields.register ProyeksiApp::CustomFieldFormat.new('empty',
                                                     label: nil,
                                                     order: 10,
                                                     formatter: 'CustomValue::EmptyStrategy')
end
