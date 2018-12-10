require 'rack/request'

module FakeSNS
  class ShowOutput
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      puts request.params.to_yaml
      result = @app.call(env)
      puts
      puts(*result.last)
      result
    end
  end
end
