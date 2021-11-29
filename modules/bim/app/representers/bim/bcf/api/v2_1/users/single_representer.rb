#-- encoding: UTF-8



module Bim::Bcf::API::V2_1
  class Users::SingleRepresenter < BaseRepresenter
    property :mail,
             as: :id

    property :name
  end
end
