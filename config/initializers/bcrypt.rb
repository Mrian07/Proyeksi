#-- encoding: UTF-8



if OpenProject::Configuration.override_bcrypt_cost_factor?
  cost_factor = OpenProject::Configuration.override_bcrypt_cost_factor.to_i
  current = BCrypt::Engine.cost

  if cost_factor < 8
    Rails.logger.warn do
      "Ignoring BCrypt cost factor #{cost_factor}. Using default (#{current})."
    end
  else
    BCrypt::Engine.cost = cost_factor
  end
end
