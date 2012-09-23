require 'em-websocket'
@socket=nil
def run_socket_channel
 EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3003) do |ws|
        ws.onopen {
          @socket=ws
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
end


socket_thread=Thread.new{run_socket_channel}
puts "Input Section"
puts "exit to quit..."
line=gets.chomp 
while line != "exit"
  if @socket != nil
    @socket.send line
  else
    puts "Ups! no connection found!!!"
  end
  puts "exit to quit..."
  line=gets.chomp   
end
