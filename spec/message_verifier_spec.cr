require "./spec_helper"

describe Kemal::ClientEngine::MessageVerifier do
  
  describe "generate" do
    it "takes a string and returns an encrypted string" do
      value = "ImEgcHJpdmF0ZSBtZXNzYWdlIg==--ca3f0ae9058a4352635139971f6e7127860671a3"
      verifier = Kemal::ClientEngine::MessageVerifier.new("s3Krit")
      result = verifier.generate("a private message")
      result.should eq value
    end
  end
end
