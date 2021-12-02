

require 'spec_helper'

describe RedirectPolicy, type: :controller do
  let(:host) { 'test.host' }

  let(:return_escaped) { true }
  let(:default) { 'http://test.foo/default' }

  let(:policy) do
    described_class.new(
      back_url,
      default: default,
      hostname: host,
      return_escaped: return_escaped
    )
  end
  let(:subject) { policy.redirect_url }

  shared_examples 'redirects to default' do |url|
    let(:back_url) { url }
    it "#{url} redirects to the default URL" do
      expect(subject).to eq(default)
    end
  end

  shared_examples 'valid redirect URL' do |url|
    let(:back_url) { url }
    it "#{url} is valid" do
      expect(subject).to eq(url)
    end
  end

  shared_examples 'valid redirect, escaped URL' do |input, output|
    let(:back_url) { input }
    it "#{input} is valid, but escaped to #{output}" do
      expect(subject).to eq(output)
    end
  end

  shared_examples 'ignores invalid URLs' do
    uris = %w(
      //test.foo/fake
      //bar@test.foo
      //test.foo
      ////test.foo
      @test.foo
      fake@test.foo
      //foo:bar@test.foo
      /../somedir
      /work_packages/../../secret
    )

    uris.each do |uri|
      it_behaves_like 'redirects to default', uri
    end
  end

  it_behaves_like 'ignores invalid URLs'
  it_behaves_like 'valid redirect URL', '/work_packages/1234?filter=[foo,bar]'

  it_behaves_like 'valid redirect, escaped URL',
                  'http://test.host/?a=\11\15',
                  'http://test.host/?a=%5C11%5C15'

  context 'without escaped return URLs' do
    let(:return_escaped) { false }
    it_behaves_like 'valid redirect URL', '/work_packages/1234?filter=[foo,bar]'
    it_behaves_like 'valid redirect URL', 'http://test.host/?a=\11\15'
  end

  context 'with relative root' do
    let(:relative_root) { '/mysubdir' }

    before do
      allow(ProyeksiApp::Configuration)
        .to receive(:[]).with('rails_relative_url_root')
        .and_return(relative_root)
    end

    it_behaves_like 'valid redirect URL', '/mysubdir/work_packages/1234'
    it_behaves_like 'valid redirect URL', '/mysubdir'
    it_behaves_like 'redirects to default', '/'
    it_behaves_like 'redirects to default', '/foobar'
    it_behaves_like 'redirects to default', '/mysubdir/../foobar'
    it_behaves_like 'redirects to default', '/mysubdir/%2E%2E/secret/etc/passwd'
    it_behaves_like 'redirects to default', '/%2E%2E/secret/etc/passwd'
    it_behaves_like 'redirects to default', '/foobar/%2E%2E/secret/etc/passwd'
    it_behaves_like 'redirects to default', 'wusdus/%2E%2E/%2E%2E/secret/etc/passwd'
  end

  describe 'auth credentials' do
    let(:back_url) { 'http://user:pass@test.host/work_packages/123' }

    it 'removes the credentials' do
      expect(subject).to eq('http://test.host/work_packages/123')
    end
  end
end
