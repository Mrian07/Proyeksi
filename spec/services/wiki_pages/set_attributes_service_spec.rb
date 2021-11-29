#-- encoding: UTF-8



require 'spec_helper'

describe WikiPages::SetAttributesService, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:contract_class) do
    contract = double('contract_class')

    allow(contract)
      .to receive(:new)
      .with(wiki_page, user, options: {})
      .and_return(contract_instance)

    contract
  end
  let(:contract_instance) do
    double('contract_instance', validate: contract_valid, errors: contract_errors)
  end
  let(:contract_valid) { true }
  let(:contract_errors) do
    double('contract_errors')
  end
  let(:wiki_page_valid) { true }
  let(:instance) do
    described_class.new(user: user,
                        model: wiki_page,
                        contract_class: contract_class)
  end
  let(:call_attributes) { {} }
  let(:wiki_page) do
    FactoryBot.build_stubbed(:wiki_page_with_content)
  end

  describe 'call' do
    let(:call_attributes) do
      {
        text: 'some new text',
        title: 'a new title',
        slug: 'a new slug',
        journal_notes: 'the journal notes'
      }
    end

    before do
      allow(wiki_page)
        .to receive(:valid?)
        .and_return(wiki_page_valid)

      expect(contract_instance)
        .to receive(:validate)
        .and_return(contract_valid)
    end

    subject { instance.call(call_attributes) }

    it 'is successful' do
      expect(subject).to be_success
    end

    context 'for an existing wiki page' do
      it 'sets the attributes' do
        subject

        expect(wiki_page.attributes.slice(*wiki_page.changed).symbolize_keys)
          .to eql call_attributes.slice(:title, :slug)

        expect(wiki_page.content.attributes.slice(*wiki_page.content.changed).symbolize_keys)
          .to eql call_attributes.slice(:text)

        expect(wiki_page.content.journal_notes)
          .to eql call_attributes[:journal_notes]
      end

      it 'does not persist the wiki_page' do
        expect(wiki_page)
          .not_to receive(:save)

        expect(wiki_page.content)
          .not_to receive(:save)

        subject
      end
    end

    context 'for a new wiki page' do
      let(:wiki_page) do
        WikiPage.new
      end

      it 'initializes the content with the user being the author' do
        subject

        expect(wiki_page.content.author)
          .to eql user
      end

      it 'sets the attributes' do
        subject

        expect(wiki_page.attributes.slice(*wiki_page.changed).symbolize_keys)
          .to eql call_attributes.slice(:title, :slug)

        expect(wiki_page.content.attributes.slice(*(wiki_page.content.changed - ['author_id'])).symbolize_keys)
          .to eql call_attributes.slice(:text)

        expect(wiki_page.content.journal_notes)
          .to eql call_attributes[:journal_notes]
      end

      it 'marks the content author to be system changed' do
        subject

        expect(wiki_page.content.changed_by_system['author_id'])
          .to eql [nil, user.id]
      end
    end
  end
end
