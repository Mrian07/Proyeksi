#-- encoding: UTF-8

class PlaceholderUsers::DeleteService < ::BaseServices::Delete
  def destroy(placeholder)
    placeholder.locked!
    ::Principals::DeleteJob.perform_later(placeholder)

    true
  end
end
