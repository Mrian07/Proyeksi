

class RbBurndownChartsController < RbApplicationController
  helper :burndown_charts

  def show
    @burndown = @sprint.burndown(@project)

    respond_to do |format|
      format.html { render layout: true }
    end
  end
end
