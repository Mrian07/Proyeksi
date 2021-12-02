

require 'spec_helper'

describe 'ProyeksiApp include wiki page macro' do
  include ActionView::Helpers::UrlHelper
  include ProyeksiApp::StaticRouting::UrlHelpers
  include ProyeksiApp::TextFormatting

  def controller
    # no-op
  end

  let(:project) do
    FactoryBot.build_stubbed :project
  end

  let(:input) {}
  subject { format_text(input, project: project) }

  def error_html(exception_msg)
    "<p class=\"op-uc-p\"><macro class=\"macro-unavailable\" data-macro-name=\"include_wiki_page\">" \
          "Error executing the macro include_wiki_page (#{exception_msg})</macro></p>"
  end

  context 'old macro syntax no longer works' do
    let(:input) { '{{include(whatever)}}' }
    it { is_expected.to be_html_eql("<p class=\"op-uc-p\">#{input}</p>") }
  end

  context 'with the new but also no longer supported syntax' do
    let(:input) { '<macro class="include_wiki_page" data-page="included"></macro>' }
    it { is_expected.to be_html_eql(error_html("The macro does no longer exist.")) }
  end
end
