require "./spec_helper"

describe Kemal::ClientEngine::MessageEncryptor do
  
  describe "verifier" do
    it "returns a MessageVerifier object" do
      secret = Slice(UInt8).new(3, 10_u8)
      sign_secret = Slice(UInt8).new(3, 10_u8)
      encryptor = Kemal::ClientEngine::MessageEncryptor.new(secret, sign_secret)
      encryptor.verifier.should be_a Kemal::ClientEngine::MessageVerifier
    end
  end
end
