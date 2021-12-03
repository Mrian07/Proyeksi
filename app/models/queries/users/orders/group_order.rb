#-- encoding: UTF-8

class Queries::Users::Orders::GroupOrder < Queries::IndividualPrincipals::Orders::GroupOrder
  self.model = User
end
