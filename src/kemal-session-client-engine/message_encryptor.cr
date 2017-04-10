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

      def decrypt_and_verify(value : String)
        _decrypt(verifier.verify(value).as(String))
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
        encrypted_data += String.new(cipher.final)

        "#{Base64.strict_encode(encrypted_data)}--#{Base64.strict_encode(iv)}"
      end

      private def _decrypt(value : String)
        encrypted_data, iv = value.split("--").map do |v|
          String.new(Base64.decode(v))
        end

        cipher.decrypt
        cipher.key = String.new(@secret)
        cipher.iv = iv
        decrypted_data = String.new(cipher.update(encrypted_data))
        decrypted_data += String.new(cipher.final)
        decrypted_data
      end
    end
  end
end
