class Groups::DeleteService < ::BaseServices::Delete
  protected

  def destroy(group)
    ::Principals::DeleteJob.perform_later(group)
    true
  end
end
