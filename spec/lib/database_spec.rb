#-- encoding: UTF-8


require 'spec_helper'

describe OpenProject::Database do
  before do
    described_class.instance_variable_set(:@version, nil)
  end

  after do
    described_class.instance_variable_set(:@version, nil)
  end

  it 'should return the correct identifier' do
    allow(OpenProject::Database).to receive(:adapter_name).and_return 'PostgresQL'

    expect(OpenProject::Database.name).to equal(:postgresql)
  end

  it 'should be able to use the helper methods' do
    allow(OpenProject::Database).to receive(:adapter_name).and_return 'PostgresQL'

    expect(OpenProject::Database.postgresql?).to equal(true)
  end

  it 'should return a version string for PostgreSQL' do
    allow(OpenProject::Database).to receive(:adapter_name).and_return 'PostgreSQL'
    raw_version = 'PostgreSQL 8.3.11 on x86_64-pc-linux-gnu, compiled by GCC gcc-4.3.real (Debian 4.3.2-1.1) 4.3.2'
    allow(ActiveRecord::Base.connection).to receive(:select_value).and_return raw_version

    expect(OpenProject::Database.version).to eq('8.3.11')
    expect(OpenProject::Database.version(true)).to eq(raw_version)
  end
end
