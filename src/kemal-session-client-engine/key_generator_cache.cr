module Kemal
  class ClientEngine
    class KeyGeneratorCache
      
      def initialize(@generator : Kemal::ClientEngine::KeyGenerator)
      end

      # This will eventually need to cache the result globally somehow
      # That will prevent the slow algorithm being run every time if
      # args are the same
      def generate_key(*args)
        @generator.generate_key(*args)
      end
    end
  end
end
