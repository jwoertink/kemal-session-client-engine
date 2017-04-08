module Kemal
  class ClientEngine
    class MessageEncryptor
      DEFAULT_CIPHER = "aes-256-cbc" 

      def initialize(@secret : Slice(UInt8), @sign_secret : Slice(UInt8))
      end

      # To encrypt a hash, convert to_json
      def encrypt_and_sign(value : String)
        verifier.generate(_encrypt(value))
      end

      def verifier
        MessageVerifier.new(String.new(@sign_secret))
      end

      def cipher
        OpenSSL::Cipher.new(DEFAULT_CIPHER)
      end

      private def _encrypt(value : String)
        cipher.encrypt
        cipher.key = String.new(@secret)
        iv = String.new(cipher.random_iv)
        encrypted_data = String.new(cipher.update(value))
        encrypted_data += String.new(cipher.finalize)

        "#{Base64.strict_encode(encrypted_data)}--#{Base64.strict_encode(iv)}"
      end
    end
  end
end
