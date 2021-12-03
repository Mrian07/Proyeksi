#-- encoding: UTF-8

class Users::MembershipsController < ApplicationController
  include IndividualPrincipals::MembershipControllerMethods
  layout 'admin'

  before_action :authorize_global
  before_action :find_individual_principal

  def find_individual_principal
    @individual_principal = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def redirected_to_tab(membership)
    if membership.project
      'memberships'
    else
      'global_roles'
    end
  end
end
