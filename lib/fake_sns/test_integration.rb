require "faraday"
require "timeout"

module FakeSNS
  class TestIntegration

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def startup_timeout
      options.fetch(:startup_timeout) { 5 }
    end

    def host
      option :sns_endpoint
    end

    def port
      option :sns_port
    end

    def start
      start! unless up?
      reset
    end

    def start!
      @pid = Process.spawn(binfile, "-p", port.to_s, "--database", database, :out => out, :err => out)
      wait_until_up
    end

    def stop
      if @pid
        Process.kill("INT", @pid)
        Process.waitpid(@pid)
        @pid = nil
      else
        $stderr.puts "FakeSNS is not running"
      end
    end

    def reset
      connection.delete("/")
    end

    def url
      "http://#{host}:#{port}"
    end

    def up?
      @pid && connection.get("/").success?
    rescue Errno::ECONNREFUSED, Faraday::Error::ConnectionFailed
      false
    end

    def data
      YAML.load(connection.get("/").body)
    end

    def drain(message_id = nil, options = {})
      path = message_id ? "/drain/#{message_id}" : "/drain"
      default = { aws_config: AWS.config.send(:supplied) }
      body = default.merge(options).to_json
      result = connection.post(path, body)
      if result.success?
        true
      else
        raise "Unable to drain messages: #{result.body}"
      end
    end

    def connection
      @connection ||= Faraday.new(url)
    end

    private

    def database
      options.fetch(:database) { ":memory:" }
    end

    def option(key)
      options.fetch(key) { AWS.config.public_send(key) }
    end


    def wait_until_up
      Timeout.timeout startup_timeout do
        sleep 0.1 until up?
      end
    rescue Timeout::Error
      fail "FakeSNS didn't start in time (timeout is #{startup_timeout} seconds)"
    end

    def binfile
      File.expand_path("../../../bin/fake_sns", __FILE__)
    end

    def out
      if debug?
        :out
      else
        "/dev/null"
      end
    end

    def debug?
      ENV["DEBUG"].to_s == "true"
    end

  end
end
