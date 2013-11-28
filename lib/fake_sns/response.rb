require "securerandom"
require "delegate"

module FakeSNS
  class Response < SimpleDelegator

    def request_id
      @request_id ||= SecureRandom.uuid
    end

    def template
      __getobj__.class.name.to_s.split("::").last.gsub(/[A-Z]/){|m| "_#{m[0].downcase}"}.sub(/_/, '') + "_response"
    end

  end
end
