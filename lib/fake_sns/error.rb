module FakeSNS

  class Error < StandardError
  end

  def self.error_type(status)
    Class.new(Error) do
      define_method :status do
        status
      end
    end
  end

  MissingAction = error_type 400
  InvalidParameterValue = error_type 400
end
