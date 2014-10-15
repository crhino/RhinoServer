class RhinoHTTPHeaders < Hash
  def parse(headers)
    headers.each do |header|
      ary = header.split(": ", 2)
      self[ary[0]] = ary[1].gsub!(/(\r\n)/, "")
    end
  end
end
