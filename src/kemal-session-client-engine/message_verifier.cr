module Kemal
  class ClientEngine
    class MessageVerifier
      def initialize(@secret : String, @digest : Symbol = :sha1)
      end

      def generate(value)
        data = Base64.strict_encode(value.to_json)
        "#{data}--#{generate_digest(data)}"
      end

      def valid_message?(signed_message : String)
        data, digest = signed_message.split("--")
        data && digest && compare(digest, generate_digest(data))
      end

      def verify(signed_message : String)
        if valid_message?(signed_message)
          data = signed_message.split("--")[0]
          decoded = String.new(Base64.decode(data))
          JSON.parse(decoded)
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
