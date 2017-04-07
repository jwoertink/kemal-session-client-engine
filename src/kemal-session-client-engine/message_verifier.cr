module Kemal
  class ClientEngine
    class MessageVerifier
      def initialize(@secret : String, @digest = "SHA1")
      end

      def generate(value)

      end
    end
  end
end
