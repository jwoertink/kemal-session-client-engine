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
  class ClientEngine < Engine
    class StorageInstance
    end

    def initialize(@secret_key_base : String)
    end

    def run_gc
      # Cookies should expire by the date
    end
    
    def create_session(session_id : String)

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
