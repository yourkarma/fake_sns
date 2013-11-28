module FakeSNS
  class ErrorResponse

    DEFAULT_CODE   = "InternalFailure"
    DEFAULT_STATUS = 500

    attr_reader :error, :parameters

    def initialize(error, parameters)
      @error = error
      @parameters = parameters
    end

    def status
      if error.respond_to?(:status)
        error.status
      else
        DEFAULT_STATUS
      end
    end

    # TODO figure out what this value does
    def type
      "Sender"
    end

    def code
      if error.respond_to?(:code)
        error.code
      elsif error.is_a?(FakeSNS::Error)
        error.class.to_s.split("::").last
      else
        DEFAULT_CODE
      end
    end

    def message
      error.message
    end

    def request_id
      @request_id ||= SecureRandom.uuid
    end

  end
end
