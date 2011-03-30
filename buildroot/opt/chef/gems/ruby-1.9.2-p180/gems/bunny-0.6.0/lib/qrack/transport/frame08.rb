
#:stopdoc:
# this file was autogenerated on Fri Jun 04 10:11:23 +0100 2009
#
# DO NOT EDIT! (edit ext/qparser.rb and config.yml instead, and run 'ruby qparser.rb')

module Qrack
  module Transport
    class Frame
	
      FOOTER = 206
			ID = 0

			@types = { 1 => 'Method',
      					 2 => 'Header',
      					 3 => 'Body',
      					 4 => 'OobMethod',
      					 5 => 'OobHeader',
      					 6 => 'OobBody',
      					 7 => 'Trace',
      					 8 => 'Heartbeat'}

      attr_accessor :channel, :payload

      def initialize payload = nil, channel = 0
        @channel, @payload = channel, payload
      end

			def id
				self.class::ID
			end
  
      def to_binary
        buf = Transport::Buffer.new
        buf.write :octet, id
        buf.write :short, channel
        buf.write :longstr, payload
        buf.write :octet, FOOTER
        buf.rewind
        buf
      end

      def to_s
        to_binary.to_s
      end

      def == frame
        [ :id, :channel, :payload ].inject(true) do |eql, field|
          eql and __send__(field) == frame.__send__(field)
        end
      end

			def self.parse buf
        buf = Transport::Buffer.new(buf) unless buf.is_a? Transport::Buffer
        buf.extract do
          id, channel, payload, footer = buf.read(:octet, :short, :longstr, :octet)
          Qrack::Transport.const_get(@types[id]).new(payload, channel) if footer == FOOTER
        end
      end

    end

    class Method < Frame
	
			ID = 1
			
      def initialize payload = nil, channel = 0
        super
        unless @payload.is_a? Protocol::Class::Method or @payload.nil?
          @payload = Protocol.parse(@payload)
        end
      end
    end

    class Header < Frame
	
			ID = 2
			
      def initialize payload = nil, channel = 0
        super
        unless @payload.is_a? Protocol::Header or @payload.nil?
          @payload = Protocol::Header.new(@payload)
        end
      end
    end

  	class Body < Frame
			ID = 3
		end
		
		class OobMethod < Frame
			ID = 4
		end
		
    class OobHeader < Frame
			ID = 5
		end
		
    class OobBody < Frame
			ID = 6
		end
		
    class Trace < Frame
			ID = 7
		end
		
    class Heartbeat < Frame
			ID = 8
		end

  end
end