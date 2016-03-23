module FakeSNS
  module Actions
    class CreatePlatformApplication < Action

      param name: "Name"
      param platform: "Platform"

      def call
        @application = (existing_application || new_application)
      end

      def arn
        application["arn"]
      end

      attr_reader :application

      private

      def new_application
        arn = generate_arn
        application_attributes = { "arn" => arn, "name" => name, "platform" => platform }
        db.platform_applications.create(application_attributes)
        application_attributes
      end

      def generate_arn
        "arn:aws:sns:us-east-1:#{SecureRandom.hex}"
      end

      def existing_application
        db.platform_applications.find { |t| t["name"] == name && t["platform"] == platform }
      end

    end
  end
end
