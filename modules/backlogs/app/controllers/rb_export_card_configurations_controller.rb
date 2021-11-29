

class RbExportCardConfigurationsController < RbApplicationController
  include OpenProject::PDFExport::ExportCard

  before_action :load_project_and_sprint

  def index
    @configs = ExportCardConfiguration.active
  end

  def show
    config = ExportCardConfiguration.find(params[:id])

    cards_document = OpenProject::PDFExport::ExportCard::DocumentGenerator.new(config, @sprint.stories(@project))

    filename = "#{@project}-#{@sprint}-#{Time.now.strftime('%B-%d-%Y')}.pdf"
    respond_to do |format|
      format.pdf do
        send_data(cards_document.render,
                  disposition: 'attachment',
                  type: 'application/pdf',
                  filename: filename)
      end
    end
  end

  private

  def load_project_and_sprint
    @project = Project.find(params[:project_id])
    @sprint = Sprint.find(@sprint_id)
  end
end
