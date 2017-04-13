module Kemal
  class ClientEngine
    class MessageVerifier
      class InvalidMessage < Exception; end

      def initialize(@secret : String, @digest : Symbol = :sha1)
      end

      # TODO: Add configuration for serializer
      def generate(value)
        data = Base64.strict_encode(value.to_json)
        "#{data}--#{generate_digest(data)}"
      end

      def valid_message?(signed_message : String)
        parts = signed_message.split("--")
        data = parts[0]
        digest = parts[1]?
        return false if data.blank? || digest.nil?
        data && digest && compare(digest, generate_digest(data))
      end

      def verify(signed_message : String)
        if valid_message?(signed_message)
          data = signed_message.split("--")[0]
          decoded = String.new(Base64.decode(data))
          JSON.parse(decoded)
        else
          raise InvalidMessage.new("Unable to verify message")
        end
      end

      def compare(a : String, b : String)
        return false unless a.bytesize == b.bytesize
        l = a.bytes
        res = 0
        begin
          b.each_byte { |byte| res |= byte ^ l.shift }
        rescue IndexError
          res = 1
        end
        res == 0
      end

      private def generate_digest(data)
        OpenSSL::HMAC.hexdigest(@digest, @secret, data)
      end
    end
  end
end
