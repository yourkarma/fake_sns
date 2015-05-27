require "fake_sns"
require "sinatra/base"

module FakeSNS
  class Server < Sinatra::Base

    before do
      content_type :xml
    end

    def database
      $database ||= FakeSNS::Database.new(settings.database)
    end

    def action
      params.fetch("Action") { raise MissingAction }
    end

    get "/" do
      database.transaction do
        database.to_yaml
      end
    end

    post "/" do
      database.transaction do
        begin
          response = database.perform(action, params)
          status 200
          erb :"#{response.template}.xml", scope: response
        rescue Exception => error
          p error
          puts(*error.backtrace)
          error_response = ErrorResponse.new(error, params)
          status error_response.status
          erb :"error.xml", scope: error_response
        end
      end
    end

    delete "/" do
      database.transaction do
        database.reset
        200
      end
    end

    put "/" do
      database.replace(request.body.read)
      200
    end

    post "/drain" do
      config = JSON.parse(request.body.read.to_s)
      begin
        database.transaction do
          database.each_deliverable_message do |subscription, message|
            DeliverMessage.call(subscription: subscription, message: message, request: request, config: config)
          end
        end
      rescue => e
        status 500
        "#{e.class}: #{e}\n\n#{e.backtrace.join("\n")}"
      else
        200
      end
    end

    post "/drain/:message_id" do |message_id|
      config = JSON.parse(request.body.read.to_s)
      database.transaction do
        database.each_deliverable_message do |subscription, message|
          if message.id == message_id
            DeliverMessage.call(subscription: subscription, message: message, request: request, config: config)
          end
        end
      end
      200
    end

  end
end
