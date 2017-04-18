# kemal-session-client-engine

Mimics Rails session cookie storage for storing session on client side for Kemal apps.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  kemal-session-client-engine:
    github: jwoertink/kemal-session-client-engine
```

## Usage

### Adding in to Kemal
**under development**

```crystal
Session.config.engine = Session::ClientEngine.new(ENV["SECRET_KEY_BASE"])

# ...
```

### Encrypt session token for Rails
this is broken still :(

### Decrypt session token from Rails
To test decrypting a token from rails, you'll need to generate a token:

```ruby
secret_key_base = "a0aaa0a00a000a00a0a0aa00a0aa000a000aa0a0a0a0a0000a0000a00aaa00000000aa0aa00000000a00000a000a000000a00aaa0a0000000a0000a0a0aaa000"
key_generator = ActiveSupport::CachingKeyGenerator.new(ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000))
secret = key_generator.generate_key("encrypted cookie")
sign_secret = key_generator.generate_key("signed encrypted cookie")
encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: JSON) #NOTE: Your rails app must use JSON serializer
encrypted_message = encryptor.encrypt_and_sign({"user_id" => 1}.to_json)
# => SOME_TOKEN_STRING
```

Take that token, and decrypt in Crystal

```crystal
require "kemal-session-client-engine"

secret_key_base = "a0aaa0a00a000a00a0a0aa00a0aa000a000aa0a0a0a0a0000a0000a00aaa00000000aa0aa00000000a00000a000a000000a00aaa0a0000000a0000a0a0aaa000"
key_generator = Kemal::ClientEngine::KeyGenerator.new(secret_key_base)
secret = key_generator.generate_key("encrypted cookie")
sign_secret = key_generator.generate_key("signed encrypted cookie")
encryptor = Kemal::ClientEngine::MessageEncryptor.new(secret, sign_secret)
encryptor.decrypt_and_verify("THE_ENCRYPTED_MESSAGE_FROM_RAILS")
```

## Contributing

1. Fork it ( https://github.com/jwoertink/kemal-session-client-engine/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jwoertink](https://github.com/jwoertink) Jeremy Woertink - creator, maintainer
