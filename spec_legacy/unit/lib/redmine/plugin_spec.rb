#-- encoding: UTF-8


require_relative '../../../legacy_spec_helper'

describe Redmine::Plugin do
  before do
    @klass = Redmine::Plugin
    # In case some real plugins are installed
    @klass.clear
  end

  after do
    @klass.clear
  end

  it 'should register' do
    @klass.register :foo do
      name 'Foo plugin'
      url 'http://example.net/plugins/foo'
      author 'John Smith'
      author_url 'http://example.net/jsmith'
      description 'This is a test plugin'
      version '0.0.1'
      settings default: { 'sample_setting' => 'value', 'foo' => 'bar' }, partial: 'foo/settings'
    end

    assert_equal 1, @klass.all.size

    plugin = @klass.find('foo')
    assert plugin.is_a?(Redmine::Plugin)
    assert_equal :foo, plugin.id
    assert_equal 'Foo plugin', plugin.name
    assert_equal 'http://example.net/plugins/foo', plugin.url
    assert_equal 'John Smith', plugin.author
    assert_equal 'http://example.net/jsmith', plugin.author_url
    assert_equal 'This is a test plugin', plugin.description
    assert_equal '0.0.1', plugin.version
  end

  it 'should requires openproject' do
    test = self
    version = OpenProject::VERSION.to_semver

    @klass.register :foo do
      test.assert requires_openproject('>= 0.1')
      test.assert requires_openproject(">= #{version}")
      test.assert requires_openproject(version)
      test.assert_raises Redmine::PluginRequirementError do
        requires_openproject('>= 99.0.0')
      end
      test.assert_raises Redmine::PluginRequirementError do
        requires_openproject('< 0.9')
      end
      requires_openproject('> 0.9', '<= 99.0.0')
      test.assert_raises Redmine::PluginRequirementError do
        requires_openproject('< 0.9', '>= 98.0.0')
      end

      test.assert requires_openproject("~> #{OpenProject::VERSION.to_semver.gsub(/\d+\z/, '0')}")
    end
  end

  it 'should requires redmine plugin' do
    test = self
    other_version = '0.5.0'

    @klass.register :other do
      name 'Other'
      version other_version
    end

    @klass.register :foo do
      test.assert requires_redmine_plugin(:other, version_or_higher: '0.1.0')
      test.assert requires_redmine_plugin(:other, version_or_higher: other_version)
      test.assert requires_redmine_plugin(:other, other_version)
      test.assert_raises Redmine::PluginRequirementError do
        requires_redmine_plugin(:other, version_or_higher: '99.0.0')
      end

      test.assert requires_redmine_plugin(:other, version: other_version)
      test.assert requires_redmine_plugin(:other, version: [other_version, '99.0.0'])
      test.assert_raises Redmine::PluginRequirementError do
        requires_redmine_plugin(:other, version: '99.0.0')
      end
      test.assert_raises Redmine::PluginRequirementError do
        requires_redmine_plugin(:other, version: ['98.0.0', '99.0.0'])
      end
      # Missing plugin
      test.assert_raises Redmine::PluginNotFound do
        requires_redmine_plugin(:missing, version_or_higher: '0.1.0')
      end
      test.assert_raises Redmine::PluginNotFound do
        requires_redmine_plugin(:missing, '0.1.0')
      end
      test.assert_raises Redmine::PluginNotFound do
        requires_redmine_plugin(:missing, version: '0.1.0')
      end
    end
  end
end