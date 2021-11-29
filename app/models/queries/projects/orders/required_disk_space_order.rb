#-- encoding: UTF-8



class Queries::Projects::Orders::RequiredDiskSpaceOrder < Queries::Orders::Base
  self.model = Project

  def self.key
    :required_disk_space
  end

  private

  def order
    with_raise_on_invalid do
      attribute = Project.required_disk_space_sum
      model.order(Arel.sql(attribute).send(direction))
    end
  end
end
