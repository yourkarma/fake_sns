require "net/http"

module FakeSNS
  class TestIntegration

    attr_reader :options

    def initialize(options = {})
      @options = options
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
      @pid = Process.spawn(binfile, "-p", port.to_s, :out => out, :err => out)
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
      @pid && connection.get("/").code.to_s == "200"
    rescue Errno::ECONNREFUSED
      false
    end

    private

    def option(key)
      options.fetch(key) { AWS.config.public_send(key) }
    end


    def wait_until_up(deadline = Time.now + 2)
      fail "FakeSNS didn't start in time" if Time.now > deadline
      unless up?
        sleep 0.1
        wait_until_up(deadline)
      end
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

    def connection
      @connection ||= Net::HTTP.new(host, port)
    end

    def debug?
      ENV["DEBUG"].to_s == "true"
    end

  end
end
