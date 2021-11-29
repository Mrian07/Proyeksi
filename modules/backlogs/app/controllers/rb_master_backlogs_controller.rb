

class RbMasterBacklogsController < RbApplicationController
  menu_item :backlogs

  before_action :set_export_card_config_meta

  def index
    @owner_backlogs = Backlog.owner_backlogs(@project)
    @sprint_backlogs = Backlog.sprint_backlogs(@project)

    @last_update = (@sprint_backlogs + @owner_backlogs).map(&:updated_at).compact.max
  end

  private

  def set_export_card_config_meta
    @export_card_config_meta = {
      count: ExportCardConfiguration.active.count,
      default: ExportCardConfiguration.default
    }
  end

  def default_breadcrumb
    I18n.t(:label_backlogs)
  end
end
