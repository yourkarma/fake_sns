module FakeSNS
  class PlatformEndpoint

    include Virtus.model

    attribute :arn, String
    attribute :platform_application_arn, String
    attribute :token, String

  end
end
