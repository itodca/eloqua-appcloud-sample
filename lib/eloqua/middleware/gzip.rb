require 'faraday'
require 'zlib'

module Eloqua
  module Middleware
    class Gzip < Faraday::Response::Middleware

      def on_complete(env)
        encoding = env[:response_headers]['content-encoding'].to_s.downcase
        case encoding
        when 'gzip'
          env[:body] = Zlib::GzipReader.new(StringIO.new(env[:body]), encoding: 'ASCII-8BIT').read
          env[:response_headers].delete('content-encoding')
        when 'deflate'
          env[:body] = Zlib::Inflate.inflate(env[:body])
          env[:response_headers].delete('content-encoding')
        end
      end
    end
  end
end
