require "fake_sns"
require "sinatra/base"

module FakeSNS
  class Server < Sinatra::Base

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
          puts *error.backtrace
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

    patch "/" do
      database.replace(request.body.read)
      200
    end

  end
end
