# Modified version of:
# Ref: https://github.com/ONsec-Lab/scripts/blob/master/xxe-ftp-server.rb

require 'socket'
server = TCPServer.new 13336
loop do
  Thread.start(server.accept) do |client|
    puts "New client connected"
    data = ""
    client.puts("220 xxe-ftp-server")
    loop {
        req = client.gets()
        puts "< "+req
        puts req.inspect
        if req.include? "USER"
            client.puts("331 password please - version check")
        else
            puts "> 230 more data please!"
            client.puts("230 more data please!")
        end
    }
  end
end
