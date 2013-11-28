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

  # Common Errors, according to AWS docs
  IncompleteSignature         = error_type 400
  InternalFailure             = error_type 500
  InvalidAction               = error_type 400
  InvalidClientTokenId        = error_type 403
  InvalidParameterCombination = error_type 400
  InvalidParameterValue       = error_type 400
  InvalidQueryParameter       = error_type 400
  MalformedQueryString        = error_type 400
  MissingAction               = error_type 400
  MissingAuthenticationToken  = error_type 403
  MissingParameter            = error_type 400
  OptInRequired               = error_type 403
  RequestExpired              = error_type 400
  ServiceUnavailable          = error_type 403
  Throttling                  = error_type 400

  # Other errors
  NotFound = error_type 404

end
