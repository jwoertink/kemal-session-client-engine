module Kemal
  class ClientEngine
    class MessageVerifier
      def initialize(@secret : String, @digest : Symbol = :sha1)
      end

      def generate(value)
        data = Base64.strict_encode(value.to_json)
        "#{data}--#{generate_digest(data)}"
      end

      private def generate_digest(data)
        OpenSSL::HMAC.hexdigest(@digest, @secret, data)
      end
    end
  end
end
