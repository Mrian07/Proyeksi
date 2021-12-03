#-- encoding: UTF-8

class UpdateTypeService < BaseTypeService
  def call(params)
    # forbid renaming if it is a standard type
    if params[:type] && type.is_standard?
      params[:type].delete :name
    end

    super(params, {})
  end
end
