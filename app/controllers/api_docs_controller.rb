#-- encoding: UTF-8

class APIDocsController < ApplicationController
  before_action :require_login

  def index
    render_404 unless Setting.apiv3_docs_enabled?

    render layout: 'angular/angular', inline: '' # rubocop:disable Rails/RenderInline
  end
end
