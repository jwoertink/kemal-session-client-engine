require "./spec_helper"

describe Kemal::ClientEngine::KeyGenerator do
  
  describe "generate_key" do
    it "returns a Byte sequence" do  
      secret_key_base = "a0aaa0a00a000a00a0a0aa00a0aa000a000aa0a0a0a0a0000a0000a00aaa00000000aa0aa00000000a00000a000a000000a00aaa0a0000000a0000a0a0aaa000"
      key_generator = Kemal::ClientEngine::KeyGenerator.new(secret_key_base)
      secret = key_generator.generate_key("encrypted cookie")
      secret_bytes = Bytes[181, 249, 255, 17, 75, 46, 170, 201, 7, 170, 190, 76, 247, 99, 238, 150, 139, 245, 109, 126, 136, 155, 192, 236, 6, 75, 24, 7, 220, 42, 104, 61, 98, 72, 186, 254, 90, 206, 229, 214, 181, 178, 245, 132, 211, 23, 128, 103, 191, 190, 151, 179, 161, 154, 128, 131, 167, 200, 242, 182, 69, 152, 207, 160]
      secret.hexstring.should eq secret_bytes.hexstring

      sign_secret = key_generator.generate_key("signed encrypted cookie")
      sign_secret_bytes = Bytes[240, 193, 187, 86, 69, 141, 180, 227, 213, 40, 91, 100, 246, 103, 148, 113, 8, 189, 69, 193, 57, 251, 48, 204, 236, 58, 119, 175, 15, 79, 86, 145, 57, 156, 234, 242, 93, 85, 215, 106, 90, 12, 110, 244, 244, 92, 140, 173, 177, 81, 218, 177, 20, 85, 210, 79, 67, 216, 35, 215, 24, 44, 87, 148]
      sign_secret.hexstring.should eq sign_secret_bytes.hexstring
    end
  end
end
