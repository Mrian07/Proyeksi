

require 'spec_helper'

describe 'projects/settings/general/show', type: :view do
  let(:project) { FactoryBot.build_stubbed(:project) }

  describe 'project copy permission' do
    before do
      assign(:project, project)
      allow(view).to receive(:labelled_tabular_form_for).and_return('')
    end

    context 'when project copy is allowed' do
      before do
        allow(project).to receive(:copy_allowed?).and_return(true)
        render
      end

      it 'the copy link should be visible' do
        expect(rendered).to have_selector 'a.copy'
      end
    end

    context 'when project copy is not allowed' do
      before do
        allow(project).to receive(:copy_allowed?).and_return(false)
        render
      end

      it 'the copy link should not be visible' do
        expect(rendered).not_to have_selector 'a.copy'
      end
    end
  end

  context 'User.current is admin' do
    let(:admin) { FactoryBot.build_stubbed :admin }

    before do
      assign(:project, project)
      allow(project).to receive(:copy_allowed?).and_return(true)
      allow(User).to receive(:current).and_return(admin)
      allow(view).to receive(:labelled_tabular_form_for).and_return('')
      render
    end

    it 'show delete and archive buttons' do
      expect(rendered).to have_selector('li.toolbar-item span.button--text', text: 'Archive')
      expect(rendered).to have_selector('li.toolbar-item span.button--text', text: 'Delete')
    end
  end

  context 'User.current is non-admin' do
    let(:non_admin) { FactoryBot.build_stubbed :user }

    before do
      assign(:project, project)
      allow(project).to receive(:copy_allowed?).and_return(true)
      allow(User).to receive(:current).and_return(non_admin)
      allow(view).to receive(:labelled_tabular_form_for).and_return('')
      render
    end

    it 'hide delete and archive buttons' do
      expect(rendered).not_to have_selector('li.toolbar-item span.button--text', text: 'Archive project')
      expect(rendered).not_to have_selector('li.toolbar-item span.button--text', text: 'Delete project')
    end
  end
end
