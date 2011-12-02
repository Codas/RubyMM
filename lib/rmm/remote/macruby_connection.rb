framework 'foundation'

module Remote
  class Connection
    # initializes a new asynchronous connection.
    #
    # Initializes a new connection to the url passed as first argument.
    #
    # second argument is a hash of callbacks methods that will be called
    # when the corrosponding event eccours. Following callbacks are available:
    #
    # * response(connection, response): As soon as the server responds to the
    #   connection request. Connection is the established connection, request
    #   a Remote::Request object.
    # * data(connection, data): Whenever a suitable chunk of Data arrives, this
    #   method will be called. Data contains the data transmitted up to this
    #   point and will be available as a utf-8 encoded string. Connection, again,
    #   is the Connection instance.
    # * error(connection, error): When an error occours at any point during the
    #   connection, this method will be called. Error is a ruby object
    #   Remote::ConnectionError with quite some information. It is, however, NOT
    #   an exception.
    # * completed(data): Gets called once, and only once, the connection is
    #   completed and the data is completely downloaded. The data is a utf-8
    #   encoded String.
    #
    # These methods must all be delivered as Procs or lambdas or otherwise
    # callable language constructs. Procs are prefered though. Instead of the
    # completed(data) callback Proc, the method also accepts a block that will
    # be executed once the connection completes.
    #
    # Example:
    # errorhandling = Proc.new do |connection, error|
    #   puts "Connection failed with error code: #{error.code)"
    # end
    # url = "http://google.com"
    # connection = Remote::Connection.new(url, {error: errorhandling}) do |data|
    #   puts "connection finished and data received."
    #   puts data
    # end
    def initialize(url, callbacks={}, &block)
      # Initialize the connection
      url = NSURL.URLWithString url
      request = NSMutableURLRequest.requestWithURL(url)
      get_cookies! request, url
      connection = NSURLConnection.connectionWithRequest(request, delegate:self)

      # assign all the callbacks
      callbacks[:completed] ||= block if block
      @callbacks = callbacks

      # Errors and warnings go here
      NSLog("No connection completion callback!") if callbacks[:completed].nil?
      raise "Connection failed!" unless connection
    end

    # get available cookies for specified request and url.
    # warning: changes the request and therefore absolutely NEEDS
    # a NSMutableURLRequest and not a NSURLRequest!
    def get_cookies!(request, url)
      host_url = NSURL.URLWithString "#{url.scheme}://#{url.host}"
      availableCookies = NSHTTPCookieStorage.sharedHTTPCookieStorage.cookiesForURL(host_url)
      headers = NSHTTPCookie.requestHeaderFieldsWithCookies(availableCookies)
      request.setAllHTTPHeaderFields(headers)
    end

    # delegate method
    #
    # Will be called when the the server responded to the connection
    # and wants to supply us with some basic information like data size etc
    def connection(connection, didReceiveResponse:response)
      @data = nil
      if callbacks[:response]
       response_hash = {
          :suggested_filename => response.suggestedFilename,
          :expected_length    => response.expectedContentLength,
          :text_encoding      => response.textEncodingName,
          :mime_type          => response.MIMEType,
          :status             => response.statusCode,
          :header             => response.allHeaderFields,
          :url                => response.URL
        }

        res = Response.new response_hash
        callbacks[:response].call(connection, res)
      end
    end

    # delegate method
    #
    # Will be called every time a reasonably sized data package arrived
    def connection(connection, didReceiveData:data)
      @data ||= NSMutableData.new
      @data.appendData(data)

      if callbacks[:data]
        callbacks[:data].call(connection, @data.to_str)
      end
    end

    # delegate method
    #
    # will be called when an error occured during the transmission
    def connection(connection, didFailWithError:error)
      if callbacks[:error]
        error_hash = {
          :code        => error.code,
          :description => error.localizedDescription,
          :reason      => error.localizedFailureReason,
          :help        => error.helpAnchor,
          :url         => error.userInfo['NSErrorFailingURLStringKey']
        }
        connection_error = ConnectionError.new error_hash
        callbacks[:error].call(connection, connection_error)
      end
    end

    # delegate method
    #
    # will be called when all data has ben received and the connecton
    # is beeing closed
    def connectionDidFinishLoading(connection)
      # TODO: Put the data into a usable object or hash or anything...
      @data = data.to_str

      if callbacks[:completed]
        callbacks[:completed].call(connection, @data)
      end
    end

    private
    attr_accessor :data, :callbacks
  end
end
