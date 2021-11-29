#-- encoding: UTF-8



require 'spec_helper'
require_relative 'shared/watcher_job'

describe Mails::WatcherAddedJob, type: :model do
  include_examples "watcher job", 'added' do
    let(:watcher_parameter) { watcher }
  end
end
