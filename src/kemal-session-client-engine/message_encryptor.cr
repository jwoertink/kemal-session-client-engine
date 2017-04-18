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
        verified = verifier.verify(value).as(String)
        _decrypt(verified)
      end

      def verifier
        MessageVerifier.new(String.new(@sign_secret))
      end

      def new_cipher
        OpenSSL::Cipher.new(DEFAULT_CIPHER)
      end

      private def _encrypt(value : String)
        cipher = new_cipher
        cipher.encrypt
        cipher.key = @secret
        iv = cipher.random_iv
        encrypted_update = cipher.update(value)
        encrypted_final  = cipher.final
        encrypted_data = encrypted_update ? String.new(encrypted_update) : ""
        encrypted_data += encrypted_final ? String.new(encrypted_final) : ""

        "#{Base64.strict_encode(encrypted_data)}--#{Base64.strict_encode(iv)}"
      end

      private def _decrypt(value : String)
        cipher = new_cipher
        encrypted_data, iv = value.split("--").map { |v| Base64.decode(v) }

        cipher.decrypt
        cipher.key = @secret
        cipher.iv = iv
        decrypted_update = cipher.update(encrypted_data)
        decrypted_final  = cipher.final
        decrypted_data = decrypted_update ? String.new(decrypted_update) : ""
        decrypted_data += decrypted_final ? String.new(decrypted_final) : ""
        JSON.parse(decrypted_data)
      end
    end
  end
end
