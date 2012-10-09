
#author: inguansoft.com
#examples to connect with ruby script
#/usr/bin/tail -f ~/git/mariana/log/development.log | ruby ./logspy.rb
#tail -f ~/git/mariana/log/ < ~/projects/web/mc/log/development.log
require 'rubygems'
require 'em-websocket'
@socket=nil
@resource = ConditionVariable.new
@mutex = Mutex.new

def run_socket_channel
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3003) do |ws|
    ws.onopen {
      @mutex.synchronize do
        @socket=ws
        @resource.signal
      end
      puts "connection stablished..."
    }
    ws.onclose { 
      @socket=nil
      puts "connection lost..."
    }
    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      ws.send "Pong: #{msg}"
    }     
  end
  exit
end
socket_thread=Thread.new{run_socket_channel}

puts "Waiting for client..."

@mutex.synchronize do
  @resource.wait @mutex
end

#TODO: handle deep client buffer


puts " ...got it!"
while line=gets
  if @socket != nil
    @socket.send line
  else
    puts "Ups! no connection found!!!"
  end
end
