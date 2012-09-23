require 'em-websocket'
#@socket=[]
 EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3003) do |ws|
        ws.onopen {
          puts "WebSocket connection open"

#  i=0
  input = "inguanzo00"       
#  while input != "exit"
#    i=i+1

       puts "Trying to send"
       ws.send(input)
       puts "sent?"

 #   input = gets.chomp 
 # end

          
          
        }
        ws.onclose { 
          puts "Connection closed"
        }
        ws.onmessage { |msg|
          puts "Recieved message: #{msg}"
          ws.send "Pong: #{msg}"
        }     
end
    
puts "Do we get here"
