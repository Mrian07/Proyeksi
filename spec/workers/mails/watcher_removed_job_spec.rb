#-- encoding: UTF-8



require 'spec_helper'
require_relative 'shared/watcher_job'

describe Mails::WatcherRemovedJob, type: :model do
  include_examples "watcher job", 'removed' do
    let(:watcher_parameter) { watcher.attributes }

    before do
      allow(Watcher)
        .to receive(:new)
        .with(watcher_parameter)
        .and_return(watcher)
    end
  end
end
