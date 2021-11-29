#-- encoding: UTF-8



module Queries::Documents
  query = Queries::Documents::DocumentQuery

  Queries::Register.filter query, Queries::Documents::Filters::ProjectFilter

  Queries::Register.order query, Queries::Documents::Orders::DefaultOrder
end
