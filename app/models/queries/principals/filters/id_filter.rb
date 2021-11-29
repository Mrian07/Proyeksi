#-- encoding: UTF-8



class Queries::Principals::Filters::IdFilter < Queries::Principals::Filters::PrincipalFilter
  def allowed_values
    [["me", "me"]] # Not the whole truth but performs better than checking all IDs
  end

  def type
    :list
  end

  def self.key
    :id
  end

  def where
    operator_strategy.sql_for_field(values_replaced, self.class.model.table_name, self.class.key)
  end

  def values_replaced
    vals = values.clone

    if vals.delete('me')
      if User.current.logged?
        vals.push(User.current.id.to_s)
      else
        vals.push('0')
      end
    end

    vals
  end
end
