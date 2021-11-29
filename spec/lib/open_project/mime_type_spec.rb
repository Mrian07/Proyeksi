#-- encoding: UTF-8


require 'spec_helper'

describe OpenProject::MimeType do
  describe '#of' do
    to_test = { 'test.unk' => nil,
                'test.txt' => 'text/plain',
                'test.c' => 'text/x-c' }
    to_test.each do |name, expected|
      it do
        expect(described_class.of(name)).to eq expected
      end
    end
  end

  describe '#css_class_of' do
    to_test = { 'test.unk' => nil,
                'test.txt' => 'text-plain',
                'test.c' => 'text-x-c' }
    to_test.each do |name, expected|
      it do
        expect(described_class.css_class_of(name)).to eq expected
      end
    end
  end

  describe '#main_mimetype_of' do
    to_test = { 'test.unk' => nil,
                'test.txt' => 'text',
                'test.c' => 'text' }
    to_test.each do |name, expected|
      it do
        expect(described_class.main_mimetype_of(name)).to eq expected
      end
    end
  end

  describe '#is_type?' do
    to_test = { ['text', 'test.unk'] => false,
                ['text', 'test.txt'] => true,
                ['text', 'test.c'] => true }

    to_test.each do |args, expected|
      it do
        expect(described_class.is_type?(*args)).to eq expected
      end
    end
  end

  it 'equals the main type for the narrow type' do
    expect(described_class.narrow_type('rubyfile.rb', 'text/plain')).to eq 'text/x-ruby'
  end

  it 'uses original type if main type differs' do
    expect(described_class.narrow_type('rubyfile.rb', 'application/zip')).to eq 'application/zip'
  end
end
