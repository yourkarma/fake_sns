require 'fake_sns'
require 'sinatra/base'
require 'pp'

module FakeSNS
  # The Sinatra end-points for the fake SNS server
  class Server < Sinatra::Base
    before do
      content_type :xml
    end

    def database
      $database ||= FakeSNS::Database.new(settings.database)
    end

    def action
      params.fetch('Action') { raise MissingAction }
    end

    get '/' do
      database.transaction do
        database.to_yaml
      end
    end

    post '/' do
      database.transaction do
        begin
          response = database.perform(action, params)
          status 200
          if action == 'Publish' && settings.auto_drain
            puts "Draining message #{response.message_id}"
            drain_message(response.message_id)
          end
          erb :"#{response.template}.xml", scope: response
        rescue Exception => error
          p error
          puts(*error.backtrace)
          error_response = ErrorResponse.new(error, params)
          status error_response.status
          database.abort
          erb :"error.xml", scope: error_response
        end
      end
    end

    delete '/' do
      database.transaction do
        database.reset
        200
      end
    end

    put '/' do
      database.replace(request.body.read)
      200
    end

    def signing_url
      host = settings.bind
      port = settings.port
      "http://#{host}:#{port}/signing-certificate.pem"
    end

    post '/drain' do
      config = JSON.parse(request.body.read.to_s)
      begin
        database.transaction do
          database.each_deliverable_message do |subscription, message|
            DeliverMessage.call(
              subscription: subscription,
              message: message,
              request: request,
              config: config,
              signing_url: signing_url
            )
            purge(message.id)
          end
        end
      rescue StandardError => e
        status 500
        "#{e.class}: #{e}\n\n#{e.backtrace.join("\n")}"
      else
        200
      end
    end

    def purge(message_id)
      return unless settings.purge_on_drain
      database.messages.delete(message_id)
    end

    def drain_message(message_id, config = {})
      database.each_deliverable_message do |subscription, message|
        next unless message.id == message_id
        DeliverMessage.call(
          subscription: subscription,
          message: message,
          request: request,
          config: config,
          signing_url: signing_url
        )
        purge(message.id)
      end
    end

    post '/drain/:message_id' do |message_id|
      config = JSON.parse(request.body.read.to_s)
      database.transaction do
        drain_message(message_id, config)
      end
      200
    end

    get '/signing-certificate(.pem)?' do
      content_type 'text/plain', charset: 'utf-8'
      File.read('keys/public.cer')
    end
  end
end
