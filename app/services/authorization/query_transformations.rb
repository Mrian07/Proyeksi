#-- encoding: UTF-8



class Authorization::QueryTransformations
  def for?(on)
    !!transformations[transformation_key(on)]
  end

  def for(on)
    transformations[transformation_key(on)]
  end

  def register(on,
               name,
               after: [],
               before: [],
               &block)

    transformation = ::Authorization::QueryTransformation.new(on, name, after, before, block)

    add_transformation(transformation)
    sort_transformations(on)
  end

  def copy
    the_new = self.class.new

    the_new.transformations = transformations.deep_dup
    the_new.transformation_order = transformation_order.deep_dup

    the_new
  end

  protected

  attr_accessor :transformations,
                :transformation_order

  private

  def transformation_key(on)
    if on.respond_to?(:to_sql)
      on.to_sql
    else
      on
    end
  end

  def transformations
    @transformations ||= {}
  end

  def transformation_order
    @transformation_order ||= ::Authorization::QueryTransformationsOrder.new
  end

  def add_transformation(transformation)
    transformations[transformation_key(transformation.on)] ||= []

    transformations[transformation_key(transformation.on)] << transformation

    transformation_order << transformation
  end

  def sort_transformations(on)
    desired_order = transformation_order.full_order

    transformations[transformation_key(on)].sort_by! { |x| desired_order.index x.name }
  end
end
