#-- encoding: UTF-8



class Authorization::AbstractQuery
  class_attribute :model
  class_attribute :base_table

  def self.query(*args)
    arel = transformed_query(*args)

    model.unscoped
         .joins(joins(arel))
         .where(wheres(arel))
         .distinct
  end

  def self.base_query
    Arel::SelectManager
      .new(nil)
      .from(base_table || model.arel_table)
  end

  def self.transformed_query(*args)
    run_transformations(*args)
  end

  class_attribute :transformations

  self.transformations = ::Authorization::QueryTransformations.new

  def self.inherited(subclass)
    subclass.transformations = transformations.copy
  end

  def self.run_transformations(*args)
    query = base_query

    transformator = Authorization::QueryTransformationVisitor.new(transformations: transformations,
                                                                  args: args)

    transformator.accept(query)

    query
  end

  def self.wheres(arel)
    arel.ast.cores.last.wheres.last
  end

  def self.joins(arel)
    arel.join_sources
  end
end
