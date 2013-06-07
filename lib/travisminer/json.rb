require 'net/https'
require 'uri'
require 'json'

module TravisMiner

  class JSONExtractor
    def initialize(url)
      @uri = URI(url)
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      @http.ca_path = '/etc/ssl/certs' if File.exists?('/etc/ssl/certs')
    end

    def get
      case response = @http.request_get(@uri.request_uri)
      when Net::HTTPSuccess then JSON.parse(response.body)
      when Net::HTTPNotFound then abort "error: project not found on Travis"
      else abort "error: Travis API returned status #{response.code}"
      end
    end
  end

end
