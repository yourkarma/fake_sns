require "fake_sns"
require "sinatra/base"

module FakeSNS
  class Server < Sinatra::Base

    def database
      $database ||= FakeSNS::Database.new
    end

    def reset
      database.reset
    end

    def action
      params.fetch("Action") { raise MissingAction }
    end

    post "/" do
      begin
        response = database.perform(action, params)
        status 200
        erb :"#{response.template}.xml", scope: response
      rescue Exception => error
        error_response = ErrorResponse.new(error, params)
        status error_response.status
        erb :"error.xml", scope: error_response
      end
    end

    delete "/" do
      reset
      200
    end

  end
end
