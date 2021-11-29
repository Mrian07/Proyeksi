#-- encoding: UTF-8



# rubocop:disable Naming/MethodName

class Authorization::QueryTransformationVisitor < Arel::Visitors::Visitor
  attr_accessor :transformations,
                :args

  def initialize(transformations:,
                 args:)
    self.transformations = transformations
    self.args = args

    super()
  end

  def accept(ast)
    applied_transformations.clear

    super
  end

  private

  def visit_Arel_SelectManager(ast)
    ast = replace_if_equals(ast, :all)

    ast.join_sources.each do |join_source|
      visit join_source
    end
  end

  def visit_Arel_Nodes_OuterJoin(ast)
    visit ast.right
  end

  def visit_Arel_Nodes_On(ast)
    ast.expr = replace_if_equals(ast.expr)

    visit ast.expr
  end

  def visit_Arel_Nodes_Grouping(ast)
    ast.expr = replace_if_equals(ast.expr)

    visit ast.expr
  end

  def visit_Arel_Nodes_Or(ast)
    ast.left = replace_if_equals(ast.left)

    visit ast.left

    ast.right = replace_if_equals(ast.right)

    visit ast.right
  end

  def visit_Arel_Nodes_And(ast)
    ast.children.each_with_index do |_, i|
      ast.children[i] = replace_if_equals(ast.children[i])

      visit ast.children[i]
    end
  end

  def method_missing(name, *args, &block)
    super unless name.to_s.start_with?('visit_')
  end

  def replace_if_equals(ast, key = nil)
    if applicable_transformation?(key || ast)
      transformations.for(key || ast).each do |transformation|
        ast = transformation.apply(ast, *args)
      end
    end

    ast
  end

  def applicable_transformation?(key)
    if transformations.for?(key) && !applied_transformations.include?(key)
      applied_transformations << key

      true
    else
      false
    end
  end

  def applied_transformations
    @applied_transformations ||= []
  end
end
