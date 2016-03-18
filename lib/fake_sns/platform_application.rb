module FakeSNS
  class PlatformApplication

    include Virtus.model

    attribute :arn, String
    attribute :name, String
    attribute :platform, String

  end
end
