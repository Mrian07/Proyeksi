#-- encoding: UTF-8

class EnumerationsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :find_enumeration, only: %i[edit update destroy]

  include CustomFieldsHelper

  def index; end

  def edit; end

  def new
    enum_class = enumeration_class(permitted_params.enumeration_type)
    if enum_class
      @enumeration = enum_class.new
    else
      render_400 # bad request
    end
  end

  def create
    enum_params = permitted_params.enumerations
    type = permitted_params.enumeration_type
    @enumeration = (enumeration_class(type) || Enumeration).new do |e|
      e.attributes = enum_params
    end

    if @enumeration.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to action: 'index', type: @enumeration.type
    else
      render action: 'new'
    end
  end

  def update
    enum_params = permitted_params.enumerations
    type = permitted_params.enumeration_type
    @enumeration.type = enumeration_class(type).try(:name) || @enumeration.type
    if @enumeration.update enum_params
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to enumerations_path(type: @enumeration.type)
    else
      render action: 'edit'
    end
  end

  def destroy
    if !@enumeration.in_use?
      # No associated objects
      @enumeration.destroy
      redirect_to action: 'index'
      return
    elsif params[:reassign_to_id]
      if reassign_to = @enumeration.class.find_by(id: params[:reassign_to_id])
        @enumeration.destroy(reassign_to)
        redirect_to action: 'index'
        return
      end
    end
    @enumerations = @enumeration.class.all - [@enumeration]
  end

  protected

  def default_breadcrumb
    if action_name == 'index'
      t(:label_enumerations)
    else
      ActionController::Base.helpers.link_to(t(:label_enumerations), enumerations_path)
    end
  end

  def show_local_breadcrumb
    true
  end

  def find_enumeration
    @enumeration = Enumeration.find(params[:id])
  end

  ##
  # Find an enumeration class with the given Name
  # this should be fail save for nonsense names or names
  # which are no enumerations to prevent remote code execution attacks.
  # params: type (string)
  def enumeration_class(type)
    klass = type.to_s.constantize
    raise NameError unless klass.ancestors.include? Enumeration

    klass
  rescue NameError
    nil
  end
end
