require "bundler/setup"
Bundler.require(:default, ENV["RACK_ENV"] || "development")

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module FakeSNS

  def self.load!
  end

end
