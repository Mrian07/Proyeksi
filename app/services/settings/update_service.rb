#-- encoding: UTF-8



class Settings::UpdateService < ::BaseServices::BaseContracted
  def initialize(user:)
    super user: user,
          contract_class: Settings::UpdateContract
  end

  def after_validate(params, call)
    params.each do |name, value|
      Setting[name] = derive_value(value)
    end

    call
  end

  private

  def derive_value(value)
    case value
    when Array
      # remove blank values in array settings
      value.delete_if(&:blank?)
    when Hash
      value.delete_if { |_, v| v.blank? }
    else
      value.strip
    end
  end
end
