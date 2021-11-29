#-- encoding: UTF-8



class Queries::Users::Orders::NameOrder < Queries::Principals::Orders::NameOrder
  # .user is important here as it forces
  # "AND users.type = 'User'" which otherwise gets lost for some reason
  self.model = User.user
end
