

require 'spec_helper'

describe I18n, 'pluralization', type: :helper do

  describe 'with slowenian language and the :two plural key missing' do
    before do
      I18n.locale = :sl
      allow(I18n.backend)
        .to(receive(:lookup))
        .and_call_original

      allow(I18n.backend)
        .to(receive(:lookup))
        .with(:sl, :label_x_projects, any_args)
        .and_return({one: "1 projekt", other: "%{count} projektov", zero: "Brez projektov"})
    end

    it 'allows to pluralize without exceptions (Regression #37607)', :aggregate_failures do
      expect(I18n.t(:label_x_projects, count: 0)).to eq 'Brez projektov'
      expect(I18n.t(:label_x_projects, count: 1)).to eq '1 projekt'
      expect(I18n.t(:label_x_projects, count: 2)).to eq '2 projektov'
      expect(I18n.t(:label_x_projects, count: 10)).to eq '10 projektov'
      expect(I18n.t(:label_x_projects, count: 20)).to eq '20 projektov'
    end
  end

  describe 'with slowenian language and the :other plural key missing' do
    before do
      I18n.locale = :sl
      allow(I18n.backend)
        .to(receive(:lookup))
        .and_call_original

      allow(I18n.backend)
        .to(receive(:lookup))
        .with(:sl, :label_x_projects, any_args)
        .and_return({one: "1 projekt", zero: "Brez projektov"})
    end

    it 'falls back to english translation (Regression #37607)', :aggregate_failures do
      expect(I18n.t(:label_x_projects, count: 0)).to eq 'Brez projektov'
      expect(I18n.t(:label_x_projects, count: 1)).to eq '1 projekt'
      expect(I18n.t(:label_x_projects, count: 2)).to eq '2 projects'
      expect(I18n.t(:label_x_projects, count: 10)).to eq '10 projects'
      expect(I18n.t(:label_x_projects, count: 20)).to eq '20 projects'
    end
  end
end
