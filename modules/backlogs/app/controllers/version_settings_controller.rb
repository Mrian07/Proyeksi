

class VersionSettingsController < RbApplicationController
  def edit
    @version = Version.find(params[:id])
  end

  private

  def authorize
    # Everyone with the right to edit versions has the right to edit version
    # settings
    super 'versions', 'edit'
  end
end
