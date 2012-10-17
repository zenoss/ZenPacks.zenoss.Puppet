######################################################################
#
# Copyright 2012 Zenoss, Inc.  All Rights Reserved.
#
######################################################################

require 'net/http'
require 'httpclient'
require 'json'


module Zenoss
    # An interface to the Zenoss JSON API 
    class Session

        def initialize(baseurl='http://localhost:8080', user='admin', password='zenoss')
            @baseurl = baseurl
            @username = user
            @password = password
            @tid = 1  # Transaction ID
            openConnection()
        end

        # Initialize the API session, log in, and store authentication cookie.
        def openConnection()

            login_url = "#{@baseurl}/zport/acl_users/cookieAuthHelper/login"
            url = URI(login_url)

            came_from = "#{@baseurl}/zport/dmd/"
            headers = {
                "__ac_name" => @username,
                "__ac_password" => @password,
                "submitted" => "true",
                "came_from" => came_from,
            }
            @client = HTTPClient.new()
            @client.receive_timeout = 300

            # Just in case we go through SSL.
            @client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
            result = @client.post(url, headers)

            if result.status == 302
                # Normally we get redirected to the login page, but if we don't
                # then nothing more is required.
                url = URI(came_from)
                result = @client.post(url, headers)
                if result.status != 200
                    # No, we don't get a HTTP 500 code.
                    raise "Bad username/password to #{@baseurl}"
                end
            end
        end

        # Perform a method call against the Zenoss router.
        def request(routerCodeName, router, method, data=[])
            # Construct a standard URL request for API calls
            url = URI("#{@baseurl}/zport/dmd/#{router}")

            # NOTE: Content-type MUST be set to 'application/json' for these requests
            headers = {
                'Content-type' => 'application/json; charset=utf-8',
            }

            request = {
              'action' => routerCodeName,
              'method' => method,
              'data' => data,
              'type' => 'rpc',
              'tid' => @tid,
            }
            reqData = [request].to_json()

            # Increment the request count ('tid'). This is important
            # if sending multiple calls over time.
            # The same call with the same tid will be ignored, but
            # the same call with a new tid will be executed.
            @tid += 1

            result = @client.post(url, reqData, headers)
            if result.status != 200
                raise "Error in JSON call"
            end

            data = JSON.load(result.http_body.content)
            return data
        end
    end
end


if __FILE__ == $0
    connection = Zenoss::Session.new()

    data = {
      'deviceClass' => '/',
      'options' => {}
    }
    result = connection.request('PuppetRouter', 'puppet_router', 'exportDevices', data=[data])
    puts result
end
