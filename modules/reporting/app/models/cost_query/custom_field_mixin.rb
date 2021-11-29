

module CostQuery::CustomFieldMixin
  include Report::QueryUtils

  attr_reader :custom_field

  SQL_TYPES = {
    'string' => 'varchar',
    'list' => 'varchar',
    'text' => 'text',
    'bool' => 'boolean',
    'date' => 'date',
    'int' => 'decimal(60,3)',
    'float' => 'decimal(60,3)'
  }.freeze

  def self.extended(base)
    base.inherited_attribute :factory
    base.factory = base
    super
  end

  def all
    @all ||= generate_subclasses
  end

  def reset!
    @all = nil

    remove_subclasses
  end

  def generate_subclasses
    WorkPackageCustomField.where(field_format: SQL_TYPES.keys).map do |field|
      class_name = "CustomField#{field.id}"
      module_parent.send(:remove_const, class_name) if module_parent.const_defined? class_name
      module_parent.const_set class_name, Class.new(self)
      module_parent.const_get(class_name).prepare(field, class_name)
    end
  end

  def remove_subclasses
    module_parent.constants.each do |constant|
      if constant.to_s.match /^CustomField\d+/
        module_parent.send(:remove_const, constant)
      end
    end
  end

  def factory?
    factory == self
  end

  def on_prepare(&block)
    return factory.on_prepare unless factory?

    @on_prepare = block if block
    @on_prepare ||= proc {}
    @on_prepare
  end

  def table_name
    @class_name.demodulize.underscore.tableize.singularize
  end

  def label
    @custom_field.name
  end

  def prepare(field, class_name)
    @custom_field = field
    @class_name = class_name
    dont_inherit :group_fields
    db_field table_name
    if field.list?
      join_table list_join_table(field)
    else
      join_table default_join_table(field)
    end
    instance_eval(&on_prepare)
    self
  end

  def list_join_table(field)
    cast_as = SQL_TYPES[field.field_format]
    cf_name = "custom_field#{field.id}"

    custom_values_table = CustomValue.table_name
    custom_options_table = CustomOption.table_name

    # CustomValues of lists MAY have non-integer values when the list contained invalid values.
    # Because of this, we do not cast the cv.value but rather the co.id

    <<-SQL
    -- BEGIN Custom Field Join: #{cf_name}
    LEFT OUTER JOIN (
    SELECT
      CAST(co.value AS #{cast_as}) AS #{cf_name},
      cv.customized_type,
      cv.custom_field_id,
      cv.customized_id
      FROM #{custom_values_table} cv
      INNER JOIN #{custom_options_table} co
      ON cv.custom_field_id = co.custom_field_id AND cv.value = co.id::VARCHAR
    ) AS #{cf_name}
    ON #{cf_name}.customized_type = 'WorkPackage'

    AND #{cf_name}.custom_field_id = #{field.id}
    AND #{cf_name}.customized_id = entries.work_package_id
    -- END Custom Field Join: #{cf_name}
    SQL
  end

  def default_join_table(field)
    <<-SQL % [CustomValue.table_name, table_name, field.id, field.name, SQL_TYPES[field.field_format]]
    -- BEGIN Custom Field Join: "%4$s"
    LEFT OUTER JOIN (
    \tSELECT
    \t\tCAST(value AS %5$s) AS %2$s,
    \t\tcustomized_type,
    \t\tcustom_field_id,
    \t\tcustomized_id
    \tFROM
    \t\t%1$s)
    AS %2$s
    ON %2$s.customized_type = 'WorkPackage'
    AND %2$s.custom_field_id = %3$d
    AND %2$s.customized_id = entries.work_package_id
    -- END Custom Field Join: "%4$s"
    SQL
  end

  def new(*)
    fail "Only subclasses of #{self} should be instanciated." if factory?

    super
  end
end
