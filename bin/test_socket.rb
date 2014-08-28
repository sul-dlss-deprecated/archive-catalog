#!/usr/bin/env ruby
# Script to test if a socket connection can be made to a remote host

require 'socket'
require 'timeout'

if ARGV.size < 2
  puts "Syntax:  test_socket.rb {host} {port} [timeout(seconds)]"
end

host = ARGV[0]
port = ARGV[1]
timeout = ARGV[2] || 5

# http://stackoverflow.com/questions/517219/ruby-see-if-a-port-is-open/#9017896
def port_open?(ip, port, seconds=5)
  Timeout::timeout(seconds) do
    begin
      TCPSocket.new(ip, port).close
      'open'
    rescue Errno::ECONNREFUSED
      'connection refused'
    rescue Errno::EHOSTUNREACH
      'unreachable'
    rescue Timeout::Error
      'timed out'
    rescue Exception
      $!.inspect
    end
  end
end


status = port_open?(host, port.to_i, timeout.to_i)
puts "#{host}:#{port} = #{status}"

