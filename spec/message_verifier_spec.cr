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

  describe "valid_message?" do
    it "returns false for an invalid message" do
      verifier = Kemal::ClientEngine::MessageVerifier.new("s3Krit")
      verifier.valid_message?("--").should eq false
      verifier.valid_message?("").should eq false
      verifier.valid_message?("abc").should eq false
    end
  end

  describe "compare" do
    it "returns true when both strings are similar" do
      verifier = Kemal::ClientEngine::MessageVerifier.new("s3Krit")
      verifier.compare("test1", "test1").should eq true
    end
  end
end
