module FakeSNS
  module Actions
    class CreatePlatformEndpoint < Action

      param app_arn: "PlatformApplicationArn"
      param token: "Token"

      def call
        @endpoint = (existing_endpoint || new_endpoint)
      end

      def arn
        endpoint["arn"]
      end

      attr_reader :endpoint

      private

      def new_endpoint
        arn = generate_arn
        endpoint_attributes = { "arn" => arn, "platform_application_arn" => app_arn, "token" => token }
        db.platform_endpoints.create(endpoint_attributes)
        endpoint_attributes
      end

      def generate_arn
        "arn:aws:sns:us-east-1:#{SecureRandom.hex}"
      end

      def existing_endpoint
        db.platform_endpoints.find { |t| t["platform_application_arn"] == app_arn && t["token"] == token }
      end

    end
  end
end
