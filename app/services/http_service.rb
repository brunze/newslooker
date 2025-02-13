class HTTPService
  def self.default
    @default_instance ||= self.new
  end

  def get_html(url)
    Excon.get(url, headers: { "Accept" => "text/html" }, expects: 200).body
  rescue Excon::Error
    raise Error
  end

  def html_page_exists?(url)
    case Excon.head(url).status
    when 200, 204 then true
    when 400..499 then false
    end
  rescue Excon::Error
    raise Error
  end

  class Error < RuntimeError; end
end
