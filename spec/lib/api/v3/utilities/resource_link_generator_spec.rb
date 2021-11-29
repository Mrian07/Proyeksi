#-- encoding: UTF-8



require 'spec_helper'

describe API::V3::Utilities::ResourceLinkGenerator do
  include ::API::V3::Utilities::PathHelper

  subject { described_class }
  describe ':make_link' do
    it 'supports work packages' do
      wp = FactoryBot.build_stubbed(:work_package)
      expect(subject.make_link(wp)).to eql api_v3_paths.work_package(wp.id)
    end

    it 'supports priorities' do
      prio = FactoryBot.build_stubbed(:priority)
      expect(subject.make_link(prio)).to eql api_v3_paths.priority(prio.id)
    end

    it 'supports statuses' do
      status = FactoryBot.build_stubbed(:status)
      expect(subject.make_link(status)).to eql api_v3_paths.status(status.id)
    end

    it 'supports the anonymous user' do
      user = FactoryBot.build_stubbed(:anonymous)
      expect(subject.make_link(user)).to eql api_v3_paths.user(user.id)
    end

    it 'returns nil for unsupported records' do
      record = FactoryBot.create(:custom_field)
      expect(subject.make_link(record)).to be_nil
    end

    it 'returns nil for non-AR types' do
      record = Object.new
      expect(subject.make_link(record)).to be_nil
    end
  end
end
