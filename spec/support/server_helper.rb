class ServerHelper

  attr_reader :port, :host, :debug

  def initialize(options = {})
    @port = options.fetch(:port, 9293)
    @host = options.fetch(:host, "localhost")
    @debug = options.fetch(:debug) { ENV["DEBUG"] }
  end

  def start
    @pid = spawn(binfile, "-p", port.to_s, :out => out, :err => out)
    wait_until_up
  end

  def stop
    if @pid
      Process.kill("INT", @pid)
      Process.waitpid(@pid)
      @pid = nil
    else
      puts "FakeSNS is not running"
    end
  end

  def reset
    Faraday.delete(url)
  end

  def wait_until_up(deadline = Time.now + 5)
    fail "Fake services didn't start in time" if Time.now > deadline
    Faraday.get(url)
  rescue Faraday::Error::ConnectionFailed
    sleep 0.1
    wait_until_up(deadline)
  end

  def binfile
    File.expand_path("../../../bin/fake_sns", __FILE__)
  end

  def url
    "http://#{host}:#{port}"
  end

  def out
    if debug.to_s == "true"
      :out
    else
      "/dev/null"
    end
  end

end
