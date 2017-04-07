module Kemal
  class ClientEngine
    class MessageEncryptor

      def initialize(@secret : Slice(UInt8), @sign_secret : Slice(UInt8))
        @cipher = "aes-256-cbc"
      end

      # To encrypt a hash, convert to_json
      def encrypt_and_sign(value : String)
        verifier.generate(_encrypt(value))
      end

      def verifier
        MessageVerifier.new(@sign_secret)
      end

      def cipher
        OpenSSL::Cipher.new(@cipher)
      end

      private def _encrypt(value : String)
        cipher.encrypt
        cipher.key = String.new(@secret)
        iv = String.new(cipher.random_iv)
        encrypted_data = String.new(cipher.update(value))
        encrypted_data += String.new(cipher.finalize)

        blob = "#{Base64.strict_encode(encrypted_data)}--#{Base64.strict_encode(iv)}"
        blob
      end
    end
  end
end
