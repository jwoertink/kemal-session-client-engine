require "kemal-session"
require "openssl"
require "openssl/pkcs5"
require "openssl/cipher"
require "openssl/hmac"
require "digest/sha1"
require "secure_random"
require "json"
require "base64"
require "./kemal-session-client-engine/*"

class Session

  # Override original to create the session differently
  def initialize(ctx : HTTP::Server::Context)
    id = ctx.request.cookies[Session.config.cookie_name]?.try &.value
    valid = false
    if id
      begin
        Session.decode(id)
        valid = true
      rescue
      end
    end

    if id.nil? || !valid
      id = SecureRandom.hex
      Session.config.engine.create_session(id)
    end

    ctx.response.cookies << Session.create_cookie(id)
    @id = id
    @context = ctx
  end

  # Decode the session token
  def self.decode(token : String)
    Session.config.engine.decode(token)
  end

  # Encode the session id
  def self.encode(id : String)

  end

  class ClientEngine < Engine
    class StorageInstance
    end

    def initialize(@secret_key_base : String)
      key_generator = Kemal::ClientEngine::KeyGenerator.new(@secret_key_base)
      secret = key_generator.generate_key("encrypted cookie")
      sign_secret = key_generator.generate_key("signed encrypted cookie")
      @encryptor = Kemal::ClientEngine::MessageEncryptor.new(secret, sign_secret)
    end

    def run_gc
      # Cookies should expire by the date
    end

    def decode(token : String)
      @encryptor.decrypt_and_verify(token)
    end
    
    def create_session(session_id : String)
      session = {"session_id" => session_id}.to_json
      @encryptor.encrypt_and_sign(session)
    end

    def destroy_session(session_id : String)

    end

    def destroy_all_sessions

    end

    def all_sessions
      
    end

    def each_session(&block)
      yield Session.new("1")
    end

    def get_session(session_id : String)

    end

    macro define_delegators(vars)
      {% for name, type in vars %}
        def {{name.id}}(session_id : String, k : String) : {{type}}
        end

        def {{name.id}}?(session_id : String, k : String) : {{type}}?
        end

        def {{name.id}}(session_id : String, k : String, v : {{type}})
        end

        def {{name.id}}s(session_id : String) : Hash(String, {{type}})
        end
      {% end %}
    end

    define_delegators({
      int: Int32,
      bigint: Int64,
      string: String,
      float: Float64,
      bool: Bool,
      object: StorableObjects,
    })
  end 
end
