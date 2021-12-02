

require 'spec_helper'
require 'proyeksi_app/auth_plugins'

describe ProyeksiApp::Plugins::AuthPlugin do
  class MockEngine
    extend ProyeksiApp::Plugins::AuthPlugin
  end

  let(:strategies) { {} }
  let(:providers_a) do
    lambda { [{ name: 'a1' }, { name: 'a2' }] }
  end
  let(:providers_b) do
    lambda { [{ name: 'b1' }] }
  end
  let(:providers_c) do
    lambda { [{ name: 'c1' }] }
  end

  let(:middlewares) { [] }

  before do
    app = Object.new
    omniauth_builder = Object.new

    allow(omniauth_builder).to receive(:provider) { |strategy|
      middlewares << strategy
    }

    allow(app).to receive_message_chain(:config, :middleware, :use) { |_mw, &block|
      omniauth_builder.instance_eval(&block)
    }

    allow(ProyeksiApp::Plugins::AuthPlugin).to receive(:strategies).and_return(strategies)
    allow(MockEngine).to receive(:engine_name).and_return('foobar')
    allow(MockEngine).to receive(:initializer) { |_, &block| app.instance_eval(&block) }
  end

  describe 'ProviderBuilder' do
    before do
      pa = providers_a.call
      pb = providers_b.call
      pc = providers_c.call

      Class.new(MockEngine) do
        register_auth_providers do
          strategy :strategy_a do; pa; end
          strategy :strategy_b do; pb; end
        end
      end

      Class.new(MockEngine) do
        register_auth_providers do
          strategy :strategy_a do; pc; end
        end
      end
    end

    it 'should register all strategies' do
      expect(strategies.keys.to_a).to eq %i[strategy_a strategy_b]
    end

    it 'should register register each strategy (i.e. middleware) only once' do
      expect(middlewares.size).to eq 2
      expect(middlewares).to eq %i[strategy_a strategy_b]
    end

    it 'should associate the correct providers with their respective strategies' do
      expect(ProyeksiApp::Plugins::AuthPlugin.providers_for(:strategy_a)).to eq [providers_a.call, providers_c.call].flatten
      expect(ProyeksiApp::Plugins::AuthPlugin.providers_for(:strategy_b)).to eq providers_b.call
    end
  end
end
