

module ProyeksiApp::Webhooks
  class Hook
    attr_accessor :name, :callback

    def initialize(name, &callback)
      super()
      @name = name
      @callback = callback
    end

    def relative_url
      "webhooks/#{name}"
    end

    def handle(request = Hash.new, params = Hash.new, user = nil)
      callback.call self, request, params, user
    end
  end
end
