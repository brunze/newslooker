class HTTPService
  def self.default
    @default_instance ||= self.new
  end

  def get_html(url)
    Excon.get(url, headers: { "Accept" => "text/html" }, expects: 200).body
  rescue Excon::Error
    raise Error
  end

  class Error < RuntimeError; end
end
