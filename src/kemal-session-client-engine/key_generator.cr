module Kemal
  class ClientEngine
    class KeyGenerator

      def initialize(@secret_key_base : String, @iterations : Int32 = 1000)
      end

      # returns `Slice(UInt8)`
      def generate_key(salt, key_size = 64)
        OpenSSL::PKCS5.pbkdf2_hmac_sha1(@secret_key_base, salt, @iterations, key_size)
      end
    end
  end
end
