# Ref: https://gist.github.com/dtchepak/13b53eef9dc6b65ae1ad
require 'webrick'

class Echo < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    puts request
    response.status = 200
    response.body = <<-EOF
    Custom response here if required
    EOF
  end
  def do_POST(request, response)
    puts request
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(:Port => 13337)
server.mount "/", Echo
trap "INT" do server.shutdown end
server.start
